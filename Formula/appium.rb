require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.20.2.tgz"
  sha256 "a707dc2f21890774b289d87a35caf5e4ca1211d794cbb4daa1b4a82174c6ab43"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "041e871dbb940d86bf7ca1c389ffd1ee4edfbebbe33e050c2c9ce614b06040f7" => :big_sur
    sha256 "73c0488d2b56b71fa63c6ac64cf3907ba3af4af58edc1eb32501f15dcca98746" => :arm64_big_sur
    sha256 "e37ee0e06e21738b0cd4b3e30ceb3699dfc2adaf310fe672d7178b9e7263dad8" => :catalina
    sha256 "272492e72dda7b421261a7197fb77dc07fcbb63f01692485cc3b94201d7afb64" => :mojave
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
