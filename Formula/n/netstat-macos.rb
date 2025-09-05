class NetstatMacos < Formula
  desc "Linux-compatible netstat for macOS"
  homepage "https://github.com/iaminci/homebrew-netstat-macos"
  url "file:///dev/null"
  version "1.0.3"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"

  depends_on "bash"

  def install
    # Create the script directly in the formula
    (bin/"netstat").write <<~EOS
      #!/bin/bash

      # netstat replacement for macOS with Linux-compatible flags
      # Version: 1.0.3

      VERSION="1.0.3"

      # Help function
      show_help() {
          cat << 'HELP'
      netstat-macos 1.0.3 - Linux-compatible netstat for macOS

      Usage: netstat [OPTIONS]

      Network statistics options:
        -t, --tcp         Display TCP connections
        -u, --udp         Display UDP connections
        -l, --listening   Show only listening ports
        -n, --numeric     Show numerical addresses instead of resolving hosts
        -p, --programs    Show PID and name of programs
        -a, --all         Show both listening and non-listening sockets
        -r, --route       Display routing table (uses native netstat)
        -i, --interfaces  Display interface table (uses native netstat)

      Combined options:
        -tulpn           Show TCP and UDP listening ports with process info (most common)
        -tulp            Same as -tulpn but resolve hostnames
        -an              Show all connections with numerical addresses

      Other options:
        -v, --version    Show version information
        -h, --help       Show this help message

      Examples:
        netstat -tulpn          # Show all listening TCP/UDP ports (Linux style)
        netstat -tlp            # Show only TCP listening ports with process info
        netstat -an             # Show all connections with numerical addresses
        netstat -r              # Show routing table (native macOS netstat)
        netstat -i              # Show network interfaces (native macOS netstat)

      Note: This tool provides Linux-compatible output for -tulpn flags.
      For other flags, it falls back to native macOS netstat.
      HELP
      }

      # Function to format IP address consistently with Linux netstat
      format_address() {
          local addr="$1"
          local type="$2"

          if [[ "$type" == "ipv6" ]]; then
              if [[ "$addr" == *"["*"]:"* ]]; then
                  port=$(echo "$addr" | sed 's/.*]://')
                  echo ":::$port"
              elif [[ "$addr" == "*:"* ]]; then
                  port=$(echo "$addr" | cut -d':' -f2)
                  echo ":::$port"
              else
                  echo "$addr"
              fi
          else
              if [[ "$addr" == "localhost:"* ]]; then
                  port=$(echo "$addr" | cut -d':' -f2)
                  echo "127.0.0.1:$port"
              elif [[ "$addr" == "*:"* ]]; then
                  port=$(echo "$addr" | cut -d':' -f2)
                  echo "0.0.0.0:$port"
              else
                  echo "$addr"
              fi
          fi
      }

      # Function to get foreign address format
      get_foreign_addr() {
          local type="$1"
          if [[ "$type" == "ipv6" ]]; then
              echo ":::*"
          else
              echo "0.0.0.0:*"
          fi
      }

      # Function to process TCP connections
      process_tcp() {
          local show_listening="$1"
          local show_programs="$2"

          # IPv4 TCP connections
          if [[ "$show_listening" == true ]]; then
              lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | grep -v "IPv6" | tail -n +2
          else
              lsof -iTCP -n -P 2>/dev/null | grep -v "IPv6" | tail -n +2
          fi | while IFS= read -r line; do
              if [[ -n "$line" ]]; then
                  cmd=$(echo "$line" | awk '{print $1}')
                  pid=$(echo "$line" | awk '{print $2}')
                  local_addr=$(echo "$line" | awk '{print $9}')
                  state="LISTEN"

                  formatted_local=$(format_address "$local_addr" "ipv4")
                  foreign_addr=$(get_foreign_addr "ipv4")

                  if [[ "$show_programs" == true ]]; then
                      program_info="$pid/$cmd"
                  else
                      program_info=""
                  fi

                  printf "%-5s %6s %6s %-23s %-23s %-11s %s\\n" \\
                      "tcp" "0" "0" "$formatted_local" "$foreign_addr" "$state" "$program_info"
              fi
          done

          # IPv6 TCP connections
          if [[ "$show_listening" == true ]]; then
              lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | grep "IPv6" | tail -n +2
          else
              lsof -iTCP -n -P 2>/dev/null | grep "IPv6" | tail -n +2
          fi | while IFS= read -r line; do
              if [[ -n "$line" ]]; then
                  cmd=$(echo "$line" | awk '{print $1}')
                  pid=$(echo "$line" | awk '{print $2}')
                  local_addr=$(echo "$line" | awk '{print $9}')
                  state="LISTEN"

                  formatted_local=$(format_address "$local_addr" "ipv6")
                  foreign_addr=$(get_foreign_addr "ipv6")

                  if [[ "$show_programs" == true ]]; then
                      program_info="$pid/$cmd"
                  else
                      program_info=""
                  fi

                  printf "%-5s %6s %6s %-23s %-23s %-11s %s\\n" \\
                      "tcp6" "0" "0" "$formatted_local" "$foreign_addr" "$state" "$program_info"
              fi
          done
      }

      # Function to process UDP connections
      process_udp() {
          local show_programs="$1"

          # IPv4 UDP connections
          lsof -iUDP -n -P 2>/dev/null | grep -v "IPv6" | tail -n +2 | while IFS= read -r line; do
              if [[ -n "$line" ]]; then
                  cmd=$(echo "$line" | awk '{print $1}')
                  pid=$(echo "$line" | awk '{print $2}')
                  local_addr=$(echo "$line" | awk '{print $9}')

                  formatted_local=$(format_address "$local_addr" "ipv4")
                  foreign_addr=$(get_foreign_addr "ipv4")

                  if [[ "$show_programs" == true ]]; then
                      program_info="$pid/$cmd"
                  else
                      program_info=""
                  fi

                  printf "%-5s %6s %6s %-23s %-23s %-11s %s\\n" \\
                      "udp" "0" "0" "$formatted_local" "$foreign_addr" "" "$program_info"
              fi
          done

          # IPv6 UDP connections
          lsof -iUDP -n -P 2>/dev/null | grep "IPv6" | tail -n +2 | while IFS= read -r line; do
              if [[ -n "$line" ]]; then
                  cmd=$(echo "$line" | awk '{print $1}')
                  pid=$(echo "$line" | awk '{print $2}')
                  local_addr=$(echo "$line" | awk '{print $9}')

                  formatted_local=$(format_address "$local_addr" "ipv6")
                  foreign_addr=$(get_foreign_addr "ipv6")

                  if [[ "$show_programs" == true ]]; then
                      program_info="$pid/$cmd"
                  else
                      program_info=""
                  fi

                  printf "%-5s %6s %6s %-23s %-23s %-11s %s\\n" \\
                      "udp6" "0" "0" "$formatted_local" "$foreign_addr" "" "$program_info"
              fi
          done
      }

      # Main function
      main() {
          show_tcp=false
          show_udp=false
          show_listening=false
          show_numeric=true
          show_programs=false
          show_all=false
          use_linux_style=false

          # Parse command line options
          while [[ $# -gt 0 ]]; do
              case $1 in
                  -t|--tcp)
                      show_tcp=true
                      use_linux_style=true
                      ;;
                  -u|--udp)
                      show_udp=true
                      use_linux_style=true
                      ;;
                  -l|--listening)
                      show_listening=true
                      use_linux_style=true
                      ;;
                  -n|--numeric)
                      show_numeric=true
                      use_linux_style=true
                      ;;
                  -p|--programs)
                      show_programs=true
                      use_linux_style=true
                      ;;
                  -a|--all)
                      show_all=true
                      use_linux_style=true
                      ;;
                  -tulpn)
                      show_tcp=true
                      show_udp=true
                      show_listening=true
                      show_numeric=true
                      show_programs=true
                      use_linux_style=true
                      ;;
                  -tulp)
                      show_tcp=true
                      show_udp=true
                      show_listening=true
                      show_programs=true
                      use_linux_style=true
                      ;;
                  -an)
                      show_all=true
                      show_numeric=true
                      use_linux_style=true
                      ;;
                  -r|--route|-i|--interfaces)
                      exec /usr/bin/netstat "$@"
                      ;;
                  -v|--version)
                      echo "netstat-macos $VERSION"
                      echo "Linux-compatible netstat replacement for macOS"
                      exit 0
                      ;;
                  -h|--help)
                      show_help
                      exit 0
                      ;;
                  *)
                      exec /usr/bin/netstat "$@"
                      ;;
              esac
              shift
          done

          if [[ "$use_linux_style" == false ]]; then
              exec /usr/bin/netstat "$@"
          fi

          if [[ "$show_tcp" == false && "$show_udp" == false ]]; then
              show_tcp=true
              show_udp=true
          fi

          if [[ "$show_listening" == true ]]; then
              echo "Active Internet connections (only servers)"
          else
              echo "Active Internet connections"
          fi

          printf "%-5s %6s %6s %-23s %-23s %-11s %s\\n" \\
              "Proto" "Recv-Q" "Send-Q" "Local Address" "Foreign Address" "State" "PID/Program name"

          if [[ "$show_tcp" == true ]]; then
              process_tcp "$show_listening" "$show_programs"
          fi

          if [[ "$show_udp" == true ]]; then
              process_udp "$show_programs"
          fi
      }

      if [[ $EUID -ne 0 && "$*" == *"p"* ]]; then
          echo "Warning: Running without sudo. Process names may not be available." >&2
          echo "For full functionality, run: sudo netstat $*" >&2
          echo "" >&2
      fi

      main "$@"
    EOS

    # Make the script executable
    (bin/"netstat").chmod 0755
  end

  def caveats
    <<~EOS
      This installs netstat-macos as 'netstat', which will override the system netstat.

      Usage examples:
        netstat -tulpn    # Show listening TCP/UDP ports with process info
        netstat -tlp           # Show TCP listening ports with process info
        netstat -r             # Show routing table (uses native netstat)
        netstat -i             # Show interfaces (uses native netstat)

      To uninstall and restore system netstat:
        brew uninstall netstat-macos
    EOS
  end

  test do
    assert_match "netstat-macos", shell_output("#{bin}/netstat --version")
    assert_match "Linux-compatible", shell_output("#{bin}/netstat --help")
  end
end
