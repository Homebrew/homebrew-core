class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.5.1.tgz"
  sha256 "12234f4d0ed85d5d5c19dc1b4eca77aec5c2517335324de3a5073e99c8b3c056"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4bc40716bdb342bfb70cc1d685187063ac065a639ace21216c1eeb6db297f9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78a5ba7092618d99f68e02b1685f4646d98e242321aab2a51800dde60bb8db06"
    sha256 cellar: :any_skip_relocation, monterey:       "2036d3e4f100a881cd32150600ccba9227909cceb603e6755a2a05876102a9da"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1d728c365d43caca8574e296fa46dad2a19fc54ada089086952b2ec38a3e38e"
    sha256 cellar: :any_skip_relocation, catalina:       "3648a6ceb2da6ebf6f2f5265bd909a3a12442bb0faeb6fb735d944d1a28aa76b"
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
