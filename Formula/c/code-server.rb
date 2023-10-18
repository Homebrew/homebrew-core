require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.17.1.tgz"
  sha256 "4cb41305a7e86aca3656a3e2a9d797baa983e56b31fbb3400bbb4d0e6ef2503b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc79c318de3213f05feac7163ad82cb5dbb0a2be8018e9544c283461da60e9da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7fbae80999e8c21859db14ad9febb3bb2ab0827d43565dd33d7c5e7e99603de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b8c331f6f611560b56a5871f4b35cdc865c870a7d91cbcdcb67bc21c974f92"
    sha256 cellar: :any_skip_relocation, sonoma:         "234287421c8d5f5bfefa233f810377cf3040fda66639276e8ce15112b2234719"
    sha256 cellar: :any_skip_relocation, ventura:        "02665b645242962808175f071c0e445c47f6aed7e0892a8392e7cd464c9593ca"
    sha256 cellar: :any_skip_relocation, monterey:       "54318d11b9eb5282d125f6edb7f2b82a9fcf0020a39b24c7c5b3b7822d3f51c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92301b1b45c357b2c928abbbeae34ee1cf3b403e1251c3cde323cd354a97a4e6"
  end

  depends_on "yarn" => :build
  depends_on "node@18"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@18"]
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
