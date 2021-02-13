class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.9.0.tgz"
  sha256 "f4e69487fb2524ac4d3e4c9914e88647d73cab502c67d932400df67a223ccb86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c7f2f97dccfea452f85bd97068e2018575afe4633173887b2c6751649ded431"
    sha256 cellar: :any_skip_relocation, big_sur:       "52be90308e8b09b5fd9d74d1778dc2d4cf43d35e048ad0e171bbfa0ff41f19fc"
    sha256 cellar: :any_skip_relocation, catalina:      "de0c1e1abca52e96877b8e62d8b52e177a67e873882f7e72bce6f2eab7736440"
    sha256 cellar: :any_skip_relocation, mojave:        "2d99d114e087e90336e5257caf14fce64b0d5db3caff357c7f86b2f81fb2292a"
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
