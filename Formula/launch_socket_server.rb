class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/sstephenson/launch_socket_server"
  url "https://github.com/sstephenson/launch_socket_server/archive/v1.0.0.tar.gz"
  sha256 "77b7eebf54a1f0e0ce250b3cf3fa19eb6bee6cb6d70989a9b6cd5b6a95695608"

  revision 2

  head "https://github.com/sstephenson/launch_socket_server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b608ede0783538b8ae28fcbd1bfcb49a6f01007223a19fe8f73233f3fe02b7" => :el_capitan
    sha256 "f167359571fcf6dc0feec94b59fb2c1936e41b6f07abe1cc35986be582ca4bca" => :yosemite
  end

  depends_on "go" => :build
  depends_on :macos => :yosemite

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :startup => true

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/launch_socket_server</string>
            <string>-</string>
          </array>
          <key>Sockets</key>
          <dict>
            <key>Socket</key>
            <dict>
              <key>SockNodeName</key>
              <string>0.0.0.0</string>
              <key>SockServiceName</key>
              <string>80</string>
            </dict>
          </dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
            <string>127.0.0.1:8080</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    launch_port = 9272
    echo_port = 6752

    (testpath/"launch_socket_server.plist").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>homebrew.mxcl.launch_socket_server_test</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/launch_socket_server</string>
            <string>/usr/bin/ruby</string>
            <string>#{testpath}/echo_server.rb</string>
          </array>
          <key>Sockets</key>
          <dict>
            <key>Socket</key>
            <dict>
              <key>SockNodeName</key>
              <string>127.0.0.1</string>
              <key>SockServiceName</key>
              <string>#{launch_port}</string>
            </dict>
          </dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
            <string>127.0.0.1:#{echo_port}</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{testpath}/launch_socket_server.log</string>
          <key>StandardOutPath</key>
          <string>#{testpath}/launch_socket_server.log</string>
        </dict>
      </plist>
    EOS

    (testpath/"echo_server.rb").write <<-EOS.undent
      require "socket"

      server = TCPServer.new("127.0.0.1", "#{echo_port}")
      socket = server.accept
      socket.puts socket.readline
    EOS

    system "launchctl", "load", testpath/"launch_socket_server.plist"

    sleep 1

    begin
      socket = TCPSocket.new "127.0.0.1", launch_port
      socket.puts "hello, world"
      output = socket.gets.strip
      socket.close
    ensure
      system "launchctl", "unload", testpath/"launch_socket_server.plist"
    end

    assert_equal "hello, world", output
  end
end
