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
    sha256 "6b4d5aa2f937e6263046ac7f2923f649e14d532cbe3351e52f9f9fb57a122665" => :big_sur
    sha256 "a5e4dd0acc061aef5be260833da11d911fde8d8892318cddba696f04430dd10b" => :arm64_big_sur
    sha256 "7017a9ddd3be7a200fc57eba2827a57e0e4b8c33a68136c5ca282393020b2dfd" => :catalina
    sha256 "b9bc4a7b8d2a4a7d997416eeafbb402b220f48694c891fcc863313321e59cc58" => :mojave
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
