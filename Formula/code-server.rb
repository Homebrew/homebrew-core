require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.9.1.tgz"
  sha256 "13643c2c29fa4b5c7293161b42fed27112b51e0f7f315f9cbece40fbf37ff45b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b370e738b9a7dd76c80cf80c69d6741632366317b61440ab679869de84d61252"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95561c4a91bf003996af35f0c2e8f2d68ffaf17c65b3e50a22783d62761f68cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6207aee543f60462b3b083382df894d97c83698f004d49d63a6d1485fe4b7250"
    sha256 cellar: :any_skip_relocation, ventura:        "0a5df2521e656d7d848a96923e7d188efa34ebe566d9af62c241f2caf62ed43c"
    sha256 cellar: :any_skip_relocation, monterey:       "f7ee5fe0d7f9644a229504af6037413e36a741eec0f6f7527087ba8b34f3d267"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a1a679bf953e520653dfed8f413d355b277013a90cde708d48b039ebac617b4"
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
