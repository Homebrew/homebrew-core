class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.4.0.tgz"
  sha256 "05aae18c0be0b6d2a2ae3c6ec3347d28c3f1b9d313fdac5a7a80792b8dac8c26"

  bottle do
    cellar :any_skip_relocation
    sha256 "264a0e3f0d0599162849cfb15b2168d99598ecefc5e8e557acf19ee66d38af12" => :catalina
    sha256 "53fb6108f1191f1c58aed508142f85bc2e4bdc598e2620b03339567f215c1829" => :mojave
    sha256 "ea8feb22ef6521c511562e693a8f4779b581ea2930fdb927bbf41b3260959467" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    system "yarn", "--production", "--frozen-lockfile"
    libexec.install Dir["*"]
    bin.mkdir
    (bin/"code-server").make_symlink "#{libexec}/out/node/entry.js"
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  plist_options :manual => "code-server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/bin/node</string>
          <string>#{libexec}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{ENV["HOME"]}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/code-server.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/code-server.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "ms-python.python"
    assert_equal "ms-python.python\n", shell_output("#{bin/"code-server"} --extensions-dir=. --list-extensions")
  end
end
