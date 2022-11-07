require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.8.3.tgz"
  sha256 "14783926dac7c211db4e98f1630522f8ddd19d3df789e744476ae127ddd5a038"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0146a54eadc3e2cf21baf26e39223708f006f1c98250300dee410357eec9f9cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44b9def45dbc491f2ed19bb1b5e2afc44d08ecaa1532dff8383c4b5ffca396a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d243fa2b135e8b4ebd8bad4d701a9f54c360ffc62ca1f710d69e0cc5f633d31"
    sha256 cellar: :any_skip_relocation, monterey:       "65b391710b6144a8d842d434d019a2379f4a9aea285211d97f7ba24d74789044"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab5dff5481fd8b9fd064eea6568344cb2e85917b1aad73795b63d6865ff79fd5"
    sha256 cellar: :any_skip_relocation, catalina:       "739311fc3f12ec628f74ac1343b217a5643eda875b48288c90ea4739839c3438"
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
