class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.7.0.tgz"
  sha256 "f8794c3b9944e50eacbeca676e20c1141cc1ff9b9866c544ca83dd7ff6ceea19"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "6b535c92a764d84a86187a40a4670053971863f02dccfe1e39990b76d71c8ed4" => :catalina
    sha256 "4f1213cfb2b8aabe3203a8796d68eefe99ed3d337c56705f3aa6bb27f35f4b20" => :mojave
    sha256 "1761a9ad3c23475e902d87d919df1e90502f31cc395a1cddeeb1af80463cc913" => :high_sierra
  end

  depends_on "python@3.9" => :build
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
    # See https://github.com/cdr/code-server/blob/master/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "ms-python.python"
    assert_match "ms-python.python",
      shell_output("#{bin/"code-server"} --extensions-dir=. --list-extensions")
  end
end
