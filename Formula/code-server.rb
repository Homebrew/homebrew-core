class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.11.1.tgz"
  sha256 "b013db409856486573ecdffbd67dc4d943a8f1e4932b33565d6c510743ce8e5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b47db3bc805926588a135ac1a6845ffb0170f7ff91c5f3506073f0b0a71b9c36"
    sha256 cellar: :any_skip_relocation, big_sur:       "827327008ad5f42a147ea889be1c569513b4b37f08b87de3ea6af7f6f8521c45"
    sha256 cellar: :any_skip_relocation, catalina:      "c16c18a1df9ba25ad8a3434478ccf4778508eb50028e844a5256aad20fea5b5c"
    sha256 cellar: :any_skip_relocation, mojave:        "7d910cc1a6d45040268e8ccbf2d9a5b6aaad85675bb1291a3e73f268236ba143"
  end

  depends_on "python@3.9" => :build
  depends_on "yarn" => :build
  depends_on "node@14"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@14"]
    system "yarn", "--production", "--frozen-lockfile"
    libexec.install Dir["*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    (bin/"code-server").write_env_script "#{libexec}/out/node/entry.js", env
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir ENV["HOME"]
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
