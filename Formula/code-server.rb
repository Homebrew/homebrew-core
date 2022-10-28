require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.8.1.tgz"
  sha256 "c35573cc9822de3983cc0d855f6a7495d45f2852dc8aefb6be5dcf4976ff3d5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5e7829686c5faee0eec887319387c0cbce527ca8dc34fecdffbb260ee96197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab08026b4bab8092ad48c63bc7da6f456bcaa81bf6815642143c9497e595b903"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe877e31e6520144f4cefb7281499c3765ed4ced38ac72ba3a9d3d56257558d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f73a3ecb3f50b1c694c3a9701ac5eb5ee57b63f6792920fba474f4be77cef1a1"
    sha256 cellar: :any_skip_relocation, catalina:       "108817686a565ce252f36fd8fea6f5682aa78e940d6d8b8282f0a5517809d52f"
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
