class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.4.1.tgz"
  sha256 "38f14f7e9307e4fea7eeeaabdcbd7ff414c41136337a04530692207263101a2a"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e60052993a7053e4814d3ea9aa1b516b5ab7131c71dc524e2edd7abdf1fa7aee" => :catalina
    sha256 "eda0ef4457730392ec9fbd0354ef3c25e67d6c658563876837c16cc994200b02" => :mojave
    sha256 "f795b83b4a1333b0da1ef805257473937783aefecc0bb93c6e6ef36d83df07e9" => :high_sierra
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
    env = { PATH: "#{HOMEBREW_PREFIX}/opt/node/bin:$PATH" }
    (bin/"code-server").write_env_script "#{libexec}/out/node/entry.js", env
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  plist_options manual: "code-server"

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
          <string>#{HOMEBREW_PREFIX}/bin/code-server</string>
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
