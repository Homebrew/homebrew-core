require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.7.0.tgz"
  sha256 "a155ea2946b9df2d7edf9a242017f920698c3b1dc5a16acc37affd1e16ede483"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ebda654ef3190bf888c650f6dfe0dafd7b5848bb5825585d186f925222b720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1606fb9ea802ec7eadbfdc03c2cc6bdffb32956b2fdce0c38cfe1b97c6a8b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "a01b0510b68334e6a18b359641884a0c5b659bf36cd70e294ac668094b6b3660"
    sha256 cellar: :any_skip_relocation, big_sur:        "9364ef16acb856aea58c6794e1f52fe6bc9415324cb495ea0ce23d9fbcddf6a1"
    sha256 cellar: :any_skip_relocation, catalina:       "aa547654cb53b98b311f89dbe82907c2b75d83047c8eb5436aeda957e25416f4"
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
