class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.4.0.tgz"
  sha256 "fc65ce860b2a7c6386788b4f36ba9954e1a606c14f2667e805a003dc81c98e28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1341e1f1f673ea30f536117cc77fd1fc42fe5e730a3859561c66d10b4a27c27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0c0e00bf6d547fca3e7d9a3270dfcf74c252c06bf3c0adc52769a3b7f2e8b4"
    sha256 cellar: :any_skip_relocation, monterey:       "6a3ee99ac0ad23bb08b5e5be9a073c09cf29ccc7b190345986fd784e777536f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d627823d15bc36888d1337e06cc831f0333873ecdb8f3d77e94a20cb42146c8"
    sha256 cellar: :any_skip_relocation, catalina:       "44d094685f8294767950936aec51833bc5d3b18d0046eaa47e4c1ea80311681e"
  end

  depends_on "bash" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build
  depends_on "node@16"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@16"]
    system "yarn", "--production", "--frozen-lockfile"
    # @parcel/watcher bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    (prebuilds/"darwin-x64").rmtree if Hardware::CPU.arm?
    (prebuilds/"darwin-arm64").rmtree if Hardware::CPU.intel?
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
