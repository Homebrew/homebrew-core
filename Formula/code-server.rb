class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.5.1.tgz"
  sha256 "12234f4d0ed85d5d5c19dc1b4eca77aec5c2517335324de3a5073e99c8b3c056"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9791ca5469ed779157ee86a7e037a792ed0216f07574b09b9340838244419bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd6829248ec4bd703088f405fa12c0362e0b6a63b7004a161d22b42f8df611eb"
    sha256 cellar: :any_skip_relocation, monterey:       "27b30d37ecf0e2aac1654444d48b8678f1496bfdea51dff02dff2bb04db1d5b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "282995a9250d4df3d6b0aea36c67ad3ffb7ad300b92546b4e9db8ec8098f8314"
    sha256 cellar: :any_skip_relocation, catalina:       "e66abbb8d38b8e2d9a75ff96f829364915f4ea3221e5ee04217d387da9682717"
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
    working_dir Dir.home
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
