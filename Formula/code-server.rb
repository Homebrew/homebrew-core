require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.10.0.tgz"
  sha256 "da4e4e4b03350d2897a7855004d89523e2ff6e95fb10601a9b744ee2e0f4d1e9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23db1042d30fff79757d2af6ccf1fe01dde644d71d38d6dbcc51505704c8bf4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9245a000a9a299c17511a5f738256648520cb0a0cbb0680752415b0b1bb4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df0e75897e1f82f1daf0d1f57ed3b705d114e072766fbeefc9cfc034b6956457"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd1f0db93df3e04a821bf9baa474abb7a6bd355f1042218d5bd2759dde9273d"
    sha256 cellar: :any_skip_relocation, monterey:       "a8ed063098474f9ee779c4f1ab9df7690778e6ef22d0e0e18a0271a9bef6851f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f85bdaa4ce540716f762658bd5fdd4be92985ebf25480191eadfa19ba442101"
  end

  depends_on "bash" => :build
  depends_on "python@3.11" => :build
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
    system "npm", "install", *Language::Node.local_npm_install_args, "--unsafe-perm", "--omit", "dev"
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
    working_dir Dir.home
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
