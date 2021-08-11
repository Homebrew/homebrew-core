class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.11.1.tgz"
  sha256 "b013db409856486573ecdffbd67dc4d943a8f1e4932b33565d6c510743ce8e5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a290c75a70f56c20b06bba441f86576c9af3d7fe0a616f2f68935a583ba5904a"
    sha256 cellar: :any_skip_relocation, big_sur:       "19badfca26fe460122acce27cff6111bcc04663125044c03b499880dc61f9250"
    sha256 cellar: :any_skip_relocation, catalina:      "b22e92f4642485a24c292201c03fb842360e917a3ca26c08ba7871c280009e3c"
    sha256 cellar: :any_skip_relocation, mojave:        "d9405b5546a725ed18a5b11ba59132ab7980ab75c162526604cd2d9c1404035f"
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
