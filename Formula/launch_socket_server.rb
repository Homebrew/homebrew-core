class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://github.com/mistydemeo/launch_socket_server/archive/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  head "https://github.com/mistydemeo/launch_socket_server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff86499103ad1d9d33cdc039e24f065aa08405bda980c9e242c46ed157bc33ff" => :catalina
    sha256 "823d84eddeb72fdabeccdc189bc19269485bfeb23d0a57824cdbf95c92a6ccb8" => :mojave
    sha256 "ef58f2afc33d6454282d1e1b92e4d16269885464707ae58079c29514f4cadc60" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :startup => true

  def plist
    <<~EOS
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
    assert_includes shell_output("#{opt_sbin}/launch_socket_server 2>&1; true"),
      "usage: #{opt_sbin}/launch_socket_server"
  end
end
