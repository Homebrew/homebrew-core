require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.20.0.tgz"
  sha256 "68abf7582e28bdee2e35f9ec6c25c78288a77c44d5fe186eaedcaa122aff5fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "733f8a8eeae5f31b9fce012077186fc0f257a9091da92754c3f3c619ffd4c7ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62475bcf8b63f909ddc6a4ef8959609951aa4a7f78cef714b1bedd8fb0cf4576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43175c8c794bc2ad51601c8a4dc8b62c3d6e29946b8ffe0481bc98227f8c54ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "4000f0a093d41898de46e44a2cf42fcd6f8457951e25713e9b911ff6232963c2"
    sha256 cellar: :any_skip_relocation, ventura:        "82577b2d4c4e4164a89a849f6dcefc6f9e6bca98d3b0e438dc3839be6760d104"
    sha256 cellar: :any_skip_relocation, monterey:       "df920dedbd44053ccf2ef5ed109b52f6ce400e23d41f0bbfc742d0c197f37fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8393b541bf675edda790a146050230beea6d3165068cc41faed358291a6cfd59"
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
