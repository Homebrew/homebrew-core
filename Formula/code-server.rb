require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.8.3.tgz"
  sha256 "14783926dac7c211db4e98f1630522f8ddd19d3df789e744476ae127ddd5a038"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dda93478432d0d471c414cc2c30d33c2064c39f118d5bc1be8be0009d1f09a76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7401780022c2837d1d150c0ea5d1565de3677640378ff31c2e7a6065d8aa5414"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8f7b22286fa286facb3d7e3978b2b94c11dc22ec4fe83c2212ae2d0435b3fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "6eb3dc5ca1b5a77d66ffb7483f5a2895154c581fff0240df7f54e06b2b69c40e"
    sha256 cellar: :any_skip_relocation, monterey:       "0974b4ad120104f3725fb746311c9e149e7e037ae99683400e925ac8beefec13"
    sha256 cellar: :any_skip_relocation, big_sur:        "3261ee61b9fa67f3ae9cae530e1a02efd990d9a48950088aedb835d7d78190c0"
    sha256 cellar: :any_skip_relocation, catalina:       "752e15e47e4f9caccc381421766ee71ad8faaac4563f4490796ba2aa57d1ac7c"
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
