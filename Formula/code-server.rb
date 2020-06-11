class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.4.1.tgz"
  sha256 "38f14f7e9307e4fea7eeeaabdcbd7ff414c41136337a04530692207263101a2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0089f5d7991510d1169fb359fe8df26d3a82a4aae2248182a4e6acd7a197feef" => :catalina
    sha256 "07c0bd4b68f52cad4e17361295df7ffbb8136fe8348fa6957b70de7e5a43706d" => :mojave
    sha256 "7f9f8a007a054e8630eb3661eba7f210e0d7062eafc5a09cfe212045c11ca9b3" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

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
    assert_equal "info  Using config file ~/.config/code-server/config.yaml\nms-python.python\n",
      shell_output("#{bin/"code-server"} --extensions-dir=. --list-extensions")
  end
end
