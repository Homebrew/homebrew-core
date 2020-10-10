class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.5.0.tgz"
  sha256 "070c59c9fd955f68441e12ac7adf39e4a96e7a287ab2c092ed39f864abc795d5"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "79ec8cadf71c1b23a92b552888a971b8cc6055a6bd25b34b74e1ab90509fd08f" => :catalina
    sha256 "437c96b5ab795a11341025a3d0640b289636ae2ef6f382c7d91cb4112d6f168c" => :mojave
    sha256 "02d2d1c07b5650a4a7786d09f75a7c988a51dd20dd3bec49f0bb4a6ba6cfa9f7" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
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
      # sed removes the leading timestamp here.
      shell_output("#{bin/"code-server"} --extensions-dir=. --list-extensions | sed 's#[^ ]* \\(.*\\)#\\1#g'")
  end
end
