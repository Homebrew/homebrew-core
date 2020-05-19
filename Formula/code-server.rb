class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.3.1.tgz"
  sha256 "576c31f3dbd542becb2f6fc408c38f2cc30755525feff1060be83a1b2214c6e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbdf0603eaeec161ad35b5c21cce1f72a9ebce016ffef0571181472e84c6883b" => :catalina
    sha256 "d6973c581af96683a4aca1dd072fb735691f211d8fd0f28484807163ec95977e" => :mojave
    sha256 "e31060511e202a1044300d731c091dcac66d89bd7e0e83aa99957d82004c6f2c" => :high_sierra
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
