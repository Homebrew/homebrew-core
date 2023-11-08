class NewnodeHelper < Formula
  desc "Web proxy that uses a distributed p2p network to circumvent censorship"
  homepage "https://www.newnode.com/newnode-vpn"
  url "https://github.com/clostra/newnode.git",
      revision: "c42a04ded55cfdff857878f4d9234950e530bb00"
  version "2.1.4"
  license ""

  depends_on xcode: ["9.3", :build]
  depends_on "mbedtls@2"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "wget"

  def install
    system "git", "clone", "--recurse-submodules", "https://github.com/clostra/newnode.git"
    system "cd newnode && ./build.sh"
    bin.install "newnode/client" => "newnode-helper"
    path = (var/"newnode-helper")
    path.mkpath
    path.chmod 0775
    path2 = (var/"log")
    path2.mkpath
    path2.chmod 0775

    plist_path = prefix/"newnode-helper.plist"
    plist_content = <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.clostra.newnode-helper</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/newnode-helper</string>
            <string>-p</string>
            <string>8006</string>
            <string>-v</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>UserName</key>
        <string>newnode</string>
        <key>WorkingDirectory</key>
        <string>#{var}/newnode-helper</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/newnode-helper.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/newnode-helper-error.log</string>
    </dict>
    </plist>
    EOS
    plist_path.write(plist_content)

    script_path = prefix/"install-newnode-helper.sh"
    script_content = <<~EOS
    #!/bin/bash
    # Installation script for newnode-helper

    # make sure we're running under sudo
    case $(whoami) in
        root);;
        *) 
        echo Please run this script using the sudo command >&2 
        echo For example: >&2
        echo '' >&2
        echo sudo #{prefix}/install-newnode-helper.sh>&2
        exit 1
        ;;
    esac

    # create user "newnode" if that user doesn't already exist
    if ! id "newnode" &>/dev/null; then
        sudo sysadminctl -addUser newnode -home /var/newnode
    fi

    # copy plist into the appropriate directory for start-at-boot
    cp #{prefix}/newnode-helper.plist "/Library/LaunchDaemons/com.clostra.newnode-helper.plist"
    launchctl load #{prefix}/newnode-helper.plist
    EOS
    script_path.write(script_content)
    script_path.chmod(0755)

    uninstall_script_path = prefix/"uninstall-newnode-helper.sh"
    uninstall_script_content = <<~EOS
    #!/bin/bash
    # uninstall script for newnode-helper
    #
    # make sure we're running under sudo
    case $(whoami) in
        root);;
        *)
        echo Please run this script using the sudo command >&2
        echo For example: >&2
        echo '' >&2
        echo sudo #{prefix}/uninstall-newnode-helper.sh >&2
        exit 1
        ;;
    esac
    if test -f #{prefix}/newnode-helper.plist; then
        launchctl unload #{prefix}/newnode-helper.plist
        rm -f #{prefix}/newnode-helper.plist
    fi
    rm -f #{prefix}/install-newnode-helper.sh
    rm -f #{prefix}/uninstall-newnode-helper.sh
    EOS
  end

  def caveats
    <<~EOS
    Please run the following command to complete the installation:

    sudo #{prefix}/install-newnode-helper.sh

    This will create the user "newnode" if that user doesn't already exist,
    and cause the newnode-helper program to be started by user "newnode"
    whenever your computer starts.  

    (A separate "newnode" user is used so that the newnode-helper program is run with 
    the least privilege it needs to work, and without granting newnode-helper the
    ability to read/write any other user's files.)


    If you need to UNinstall newnode-helper, run the command:

    sudo #{prefix}/uninstall-newnode-helper.sh

    Then run:

    brew uninstall newnode-helper
    EOS
  end

#  service do
#    run [opt_bin/"newnode-helper", "-p", "8006", "-v"]
#    keep_alive true
#    working_dir var/"newnode-helper"
#    log_path var/"log/newnode-helper.log"
#    error_log_path var/"log/newnode-helper-error.log"
#  end

#  test do
#    # use wget to try to download a file via the newnode's HTTP proxy
#    # if that works, newnode vpn is working
#    ENV["https_proxy"] = "http://localhost:8006"
#    sleep 5
#    system "wget", "https://cnn.com"
#  end
end
