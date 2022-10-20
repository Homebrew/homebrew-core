require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.7.1.tgz"
  sha256 "1be32c378fae5611767b5fa9994d41504ea3ee43f6380485d00029d6e45b2715"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "125454071bedcc5cbce45c74c185134fcd2bffe5cd3c5eea91dc39602fe98a0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164eee676bf783845fad759792fdeca9aba1f268ffbe9d62b21971070fdaca5d"
    sha256 cellar: :any_skip_relocation, monterey:       "17320f0f8302fc6e15c00135f696222d5ceebf25e0dab5d5edebb394c610e8a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd6f23ee71e0c438ed9be23f87880cf52b7d0ed1454717c4707932265466ef54"
    sha256 cellar: :any_skip_relocation, catalina:       "67e795cd042821b95b62f43a3b03eabe5b84fc67bb229bdeb7b6533e5b88642d"
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
