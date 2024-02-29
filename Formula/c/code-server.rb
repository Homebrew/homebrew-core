require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.21.2.tgz"
  sha256 "8c2771756245d0ea4c6ca98a4dbca878cf6d04707537ccf79999f0c91c7e04d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feb489e83a32b1c636a5961c11446d448cc429b020695e1820dae694e4554dd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d11d7a31098557f14489ba2934c398db410191e89087230f8e63b35ba72ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d9860e9b45630bc38e8ab79528ef4376cd00b73c09c4ed6fbde9af720fdcc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a82e1e8517a672cb0fcac306445a19aa9c4c37bcc006cfb4a5d237119bd9e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "e1ed45528b09c451091fa6f32ebc9276d7e003e3405b51c08faadd51ee3c6185"
    sha256 cellar: :any_skip_relocation, monterey:       "4d7549668a9ad825400b43aa056c0b233aca3dd34db92254c0a279a4eec5866d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94349ed70e6c3ebe47b42eccd4ba60e8a9771c1d74d22c0e6af57b9311741917"
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
