require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.21.1.tgz"
  sha256 "8d533f06c4fdad73c720ad4f5129b0742ab1f7420726528f88c3db50722f0d95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81b6cdd5dd82f84309ebce95bd8fcf52f32efcb38d8bb968e6184c8b2ecc83b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8723fb89100a423f632cd9e3fb9cea4dc7c1807aa9d14413031d5dff529508aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c088a10cd9f206362b096da681f6d3466f9d5671e2d8227f5457f528adf66cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b39d35a3f1080c550aa284c944638d7c5ed003498e5fa38ad33d99c11e92129"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3e443ba0c5bcd6bf59079dd35cbc6976e7fb7c05a45ed8069c2ca892aeb4cb"
    sha256 cellar: :any_skip_relocation, monterey:       "67dc957e0b9f8a689a8b82b88d605a9a68f02f1092a63e8f58093cd31b8820ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be010361acc94097164ef77b1d0a28542dbd58f99b244341b5e2074aadc85e21"
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
