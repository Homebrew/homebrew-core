class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.0.1.tgz"
  sha256 "2d10605cb9f390c97efba8ec213194f2d5ea239f05ced2f98098fad69b488d5b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "81d8f94667ff4bd66a481511a3b7746de8913e2b9ddceb3baaa3f318ab2c84f1"
    sha256 cellar: :any, arm64_big_sur:  "032db3d50ce60e2d53a6e805ad727bde4164edb4980516e541e5b67460ba11fd"
    sha256 cellar: :any, monterey:       "20c8fe67ebf46cc279e65e8e95343a8332871522cd6fc9140a6c904703dee793"
    sha256 cellar: :any, big_sur:        "d0663198e98bcfa71fe2bd9a8434da1d856ca84dc87964abd0d5904d791d01bf"
    sha256 cellar: :any, catalina:       "82f453942a359cb794eb057d835fbf188fe0fab66cbf6b76985f8a7a410f780f"
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
    prebuilds = buildpath/"vendor/modules/code-oss-dev/node_modules/@parcel/watcher/prebuilds"
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
