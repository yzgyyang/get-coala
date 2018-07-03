#!/bin/sh
set -e

# This script is meant for quick & easy install via:
#   $ curl -fsSL URL_HERE | sh

get_platform() {
	platform=$(uname)
	echo ${uname}
}

command_exist() {
	command -v "$@" > /dev/null 2>&1
}

freebsd_init() {
	${sh_c} 'ASSUME_ALWAYS_YES=yes pkg bootstrap'
	${sh_c} 'pkg update'
}

setup() {

	user=$(id -un 2>/dev/null || true)
	sh_c='sh -c'

        if [ ${user} != 'root' ]; then
                if command_exist sudo; then
                        sh_c='sudo -E sh -c'
                elif command_exist su; then
                        sh_c='su -c'
                else
			echo Error: this installer needs the ability to run commands as root.
                        echo Neither "sudo" or "su" is available on this system.
			exit 1
		fi
	fi

        get_platform
	case ${platform} in
		FreeBSD)
			freebsd_init
		;;
	esac
}

setup

