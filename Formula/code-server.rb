class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.2.0.tgz"
  sha256 "bc8a450af38e8a937146a5c2e84ca3fb0cb99be2ff8f3a445ec5e9705068b324"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44811ea7ef463c3271738c8e1d6ddf3c61bad7f242aa646703903b968ce7698a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c40829a209da88bfcf07273bd5d712fd027d6bbd48c5f0e66cf9a6c71e6b078"
    sha256 cellar: :any_skip_relocation, monterey:       "8579502faadeeeeee97ac91782b0251ec910c5c06ef1f4128c1be2b3e5b11332"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f2974febc7bde87cc1b0b620952a47af60df10dcad876a641b91ba257da0e0b"
    sha256 cellar: :any_skip_relocation, catalina:       "7b3c83e1be28e553ba44925969cdf35cbe8717862c9e029e7bc9437bbc5dc83b"
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
