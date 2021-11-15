class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://github.com/mistydemeo/launch_socket_server/archive/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  license "MIT"
  head "https://github.com/mistydemeo/launch_socket_server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055953e5098f4c8e2c823d58e123eb3a905174c9619791b3fa54de1d671b193d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95b2bbe04b54feb6b103b5ead74f984160ff920a8914619004b40c1402bceb7"
    sha256 cellar: :any_skip_relocation, monterey:       "165fd5a279db8b88e586ca82f2c1017946a7675c8f0c158921d9cb48d152e13b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d490a674d736272ea67f2289d5eb715b5aa48acf5e289a6a8e8327cd4cbc4a4"
    sha256 cellar: :any_skip_relocation, catalina:       "ff86499103ad1d9d33cdc039e24f065aa08405bda980c9e242c46ed157bc33ff"
    sha256 cellar: :any_skip_relocation, mojave:         "823d84eddeb72fdabeccdc189bc19269485bfeb23d0a57824cdbf95c92a6ccb8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ef58f2afc33d6454282d1e1b92e4d16269885464707ae58079c29514f4cadc60"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options startup: true

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
