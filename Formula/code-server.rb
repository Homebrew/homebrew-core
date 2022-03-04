class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.1.0.tgz"
  sha256 "4f0e5aa6ae5be84cf497fc3699a22f1ec17e9710759d627a74a11763271e2510"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4e9c96957c8af6d4a6b96e800c1590f90112a58ab3abdb97dfc84c10354bfb98"
    sha256 cellar: :any, arm64_big_sur:  "94f657a8e93216fa36fe06a1a29a98e089c15c40a25a16b79ac58f6ed6f2940c"
    sha256 cellar: :any, monterey:       "3b8089f0154639d0398b5b6865729a6bbed6491534af23ec2831ca6e9fe53b3a"
    sha256 cellar: :any, big_sur:        "f161223669bdf4dcb24d2b89b9e87645c0b32adc6747d81fe4d61b9636092729"
    sha256 cellar: :any, catalina:       "387ad90bcb83c2e8ab2a969c319c9eecf9d993a77165ec300c0f439d4a967656"
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
