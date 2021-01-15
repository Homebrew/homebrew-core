require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.20.1.tgz"
  sha256 "fc8b14e7cba02a7fbb61aeead75fe2494a011917bdc118c9a31cb4a0d88ef58f"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "bbb2930540b125c48963d0b25ac3a37332546c7494a403a7240c72478d17d9f7" => :big_sur
    sha256 "24f02c89308127b41104e2ccdf2f18b79956c6400fb9238d7f63426199ac32a6" => :arm64_big_sur
    sha256 "e0adec32b1add00a77d3657291d8e917cf996af37f9ec5faed259b09d1c6980f" => :catalina
    sha256 "cbbfcc457b1d406b16d6b37b332724b99c949473c1e0deb07c580d5e520569b0" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  plist_options manual: "appium"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{bin}/appium</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/appium-error.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/appium.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
