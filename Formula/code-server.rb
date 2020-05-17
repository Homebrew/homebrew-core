class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.3.0.tgz"
  sha256 "e59a1e40f32fd69ac9b0554a14ae385dbc1c55bd04c29d85f55d1300cad951bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "50a9c5d95880d9bd681d350f9e7aed4673ad3d44031278e790b941dc33378cac" => :catalina
    sha256 "dc3772694186baf83b3cf5c58dddced422bd5b536d117e15de209d7709cdfaf3" => :mojave
    sha256 "73e50a6cefd12f146537dabbc6dad43d595decd9c198ec312516ef4813773219" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    system "yarn", "--production"
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
