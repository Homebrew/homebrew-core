require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.16.1.tgz"
  sha256 "9fb4ffa24159d24856e357b1633d22672c82404d1ca5e8888e57f66c567ab8b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4258849d6e567f4edd19ba7c44786e8dae26a3f50c75bff4d92211cf97f9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e7dfd891f1802cd93251633d0dfe9e055ec40ffa54b305390bb06e440f17bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdd6548cef786061d209d89817ad850344572400b5bbfbb77fd6c8c8da3481f"
    sha256 cellar: :any_skip_relocation, ventura:        "835210f4cc9b572b881f1494e91637ccad1d16596e62db2f659dc8edac0d6599"
    sha256 cellar: :any_skip_relocation, monterey:       "cacd041fb8ca7ae1991baea416cbbeeee83bbc388ed979a4ecf9c7063dde06dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c1b29e3041f5618aae182dc5147fa695a152594ba5e35bd7ea0471f110f66be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1d2a3eecfb582f1aaf8cb012ec22a704c83f1fe38aabd996687bc68aca1b79"
  end

  depends_on "yarn" => :build
  depends_on "node@16" # Use `node@18` after https://github.com/coder/code-server/issues/6230

  uses_from_macos "python" => :build

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
    arch_string = (Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s)
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    # Homebrew only supports glibc-based Linuxes, avoid missing linkage to musl libc
    (prebuilds/"linux-x64/node.napi.musl.node").unlink
    current_prebuild = prebuilds/"#{OS.kernel_name.downcase}-#{arch_string}"
    unneeded_prebuilds = prebuilds.glob("*") - [current_prebuild]
    unneeded_prebuilds.map(&:rmtree)

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
