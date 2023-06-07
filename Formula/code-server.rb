require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.13.0.tgz"
  sha256 "3f8916f68fbb7b0bd9c1e344a225e60d2d37ffbf238b2bbb8be185e346c808a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4864e563ef048e2b9a394c71f50c4ce48950f786a30ec645975e3cb702224272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0237aa01e26ac97b9c843792ecce61408d2974d1431181ab06e5ebe3519aa486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92aeaf01011b28a7a261c31a8a3f3ac0e79d907fb37bd7128f3769f8bbc808fa"
    sha256 cellar: :any_skip_relocation, ventura:        "39ccd51a012294abe54a2311b92d65ee3954e20fa69ce95d403f5b96c13b1a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "10272ce103dcbb262bd8b6cae0f8761e62a36ca382565ff49495e45c8fe77e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "54d3330b21f497364271c55258478d420665913716f6704e7dae3717ac0a322a"
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
