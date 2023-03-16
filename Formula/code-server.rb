require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.11.0.tgz"
  sha256 "ea69ebed2556c5c4a2c6b1e65d1a7956993f27f7fb1e62dc25d6e33edabcd319"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f212f825249b384339566adb3fa369d850debf3ecd8bfbd1d330844b37223f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbee41082cc46b824361f22e3a5ce85f37b991d178a9726ad67ba9f1b84c0b0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c95911a9ff779dd474dfcfdc566ec07ee8afbd2dd2f4d7a7d32470507b32fd"
    sha256 cellar: :any_skip_relocation, ventura:        "a5b483a5201d666d283849c94120bc52b75d3cd6f367acb52dabe9bffd7ec976"
    sha256 cellar: :any_skip_relocation, monterey:       "7c961766e78ce941510c40f39af236d966fd4cee70de97b7bdc3785d20bffe1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d1b691c3a7285b012f591656930a3690087ddf9760ae1f9ef5d1f12138ccd5"
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
