class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.11.0.tgz"
  sha256 "412990d54ab32b6a6d01d84e7441bdd2a3f0d66c1d3dc79db0b60b6042573f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9557e950e9769c5d8203532063ae40922db71581cb1f9940a7c017d4c8b89569"
    sha256 cellar: :any_skip_relocation, big_sur:       "54eabb3f6db18a6af7efb52d3400428ccf0f16e92b5a9b097779852ed5fb0dcc"
    sha256 cellar: :any_skip_relocation, catalina:      "5d23e4384836aa2f98da82bc4b6f16736f438699918f72d8d397981c480742b8"
    sha256 cellar: :any_skip_relocation, mojave:        "cbdba6aac63ee84b6261caeee1791537387856e2776c1acb9c60b05001fa3d30"
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
