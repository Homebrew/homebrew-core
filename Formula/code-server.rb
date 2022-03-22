class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.2.0.tgz"
  sha256 "bc8a450af38e8a937146a5c2e84ca3fb0cb99be2ff8f3a445ec5e9705068b324"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "984f3070138600afb99d89dce861cfbd5cb930db48053a4779293c851a999377"
    sha256 cellar: :any, arm64_big_sur:  "96746096b2efdf0139874df821db6947924788156bf4ae44fe9a67e6538cdf8a"
    sha256 cellar: :any, monterey:       "4f6b5ef1ac015003daafbaa781b8b55ea0e6b76560d928df23fa4fac62f87742"
    sha256 cellar: :any, big_sur:        "8fb769d31eadcb11f88cfc0cf2e2666c04d4ec4d4cdfa31ce44a81914229796c"
    sha256 cellar: :any, catalina:       "a91151dff53840d5d44520357d8fcf7aa3e9c04e1162540d4a22be7232e8815a"
  end

  depends_on "bash" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build
  depends_on "node@14"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@14"]
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
