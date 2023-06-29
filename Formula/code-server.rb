require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.14.1.tgz"
  sha256 "b8cba290805f3cf6f48f8d9b529283ca1d23dfa7645ff2ef23c2a6209744edde"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a0ad235d539c1a50d250588e8f31916e074752a788a07f90d238c424cdeec6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c0d6f7c745ee64f37bd866e6e63d9bd16d82f7ac53ee8b4114a11346638e5de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7fad60beeebe732a9c79f0e1efeb415e66a3a07a73770cb4026275aec201ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "cb8b2785ca655b0c91ab2d4913eff9fde2b0f564d6bcc94b005a879431cabf3a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb077ee01c90448af61acc4fbf924b5ce7b543d9e1e371eca9322d50e5b2a7f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "eba4f83966247391f40cd65e762720df45dd7db1700baec87eb757068c225822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764494f95af4d351336e80eb11963016d610706df1ef8bd1b9693e6d31eec080"
  end

  depends_on "bash" => :build
  depends_on "python@3.11" => :build
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
