require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.7.1.tgz"
  sha256 "1be32c378fae5611767b5fa9994d41504ea3ee43f6380485d00029d6e45b2715"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "844317eb1ba4b06eab347d8b0939f05beb98b050c3176c1e5a25797be82cb75c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "546a1f5d58bf95281172b930635cf44f5507f435cb9a8700860e7b365ec3b5f8"
    sha256 cellar: :any_skip_relocation, monterey:       "789545aef97ac2cc9667cb5b28d16b9d985e6aaf52d395ba298e33ee4e51fa75"
    sha256 cellar: :any_skip_relocation, big_sur:        "447ffd3c3506485823330f80d1520901d73423135d945eb81f1eaa013a552a9a"
    sha256 cellar: :any_skip_relocation, catalina:       "c2ce8922329f5151d8f6d1144e9f6414be878c164bbfffa55012096bdce6fd92"
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
