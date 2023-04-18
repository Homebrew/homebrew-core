require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.11.0.tgz"
  sha256 "ea69ebed2556c5c4a2c6b1e65d1a7956993f27f7fb1e62dc25d6e33edabcd319"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b578bed0083f34b8d8356a2ed28c9b6811537623946f5e10a7dd1050aafe423e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640007ec3cf43f3a020c1bee827f8e3b982b5fcef807ab49ace8ac57d5b6e5a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc6d0e989b0d3e27030ba6ce8f878f1a7c258557a148e2f00d73ab2ba3f3248"
    sha256 cellar: :any_skip_relocation, ventura:        "cc0c4929708bdb91d13f6017e3ac8c95faeca0404e9592bc0f4130a1ed0fe529"
    sha256 cellar: :any_skip_relocation, monterey:       "780c9cf9a707a2d5e565cf38d3df1f24ede9334c5607ddb2b061b185756ee36b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f28c1920bff008b7166f4d4885c3c33dabfd1e0fcec1ace33de446c0813e1ee9"
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
