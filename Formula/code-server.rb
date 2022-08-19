class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.6.0.tgz"
  sha256 "010ba1b4349730f412c72255f842c56f292d6944c2220e10d7f5b5bf34491f82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9190ac1b3d6f582caad59f4057a1daf95095b8f91d891e09c9847b4a9e47c5dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2908468d192059c1c5f3323ea1b2515886e4a163c316ea95c04a9f2e86153b9b"
    sha256 cellar: :any_skip_relocation, monterey:       "fc01ee91454a7f2089fc55b84b56d03f371f87e3bb7020a51a7903fac851f702"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b3d05f54fa3da1d3a5484cf17774713aa3c2f2f2a11f0002beb35cce40d2bb"
    sha256 cellar: :any_skip_relocation, catalina:       "dc5a889255e5c648bdaca25fc7a221599c8e4c2e534b0bc51cd8b8874d2ebee1"
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
