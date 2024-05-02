require "language/node"

class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.22.1.tgz"
  sha256 "46638c295b35b5212ed3e4a5d92206fec6e3c75f5d69f24764413e6358aaca6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd9c1f70af7184bac8deacdf574f9608238f4c85c2800cc4b9ac4c4ad764118c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab831d6f21fff3144e8b2f7621ba2976dd23851494d040c9f1d8f5959fdc872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64e8d962e04dc008ede631c079af35aa46427a8be0b0f21bf872f1e4c919ec2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7780c06a13f7b3323ca8211a57f10aef6cca0752dc76b50d395cbb9fb6b7f44"
    sha256 cellar: :any_skip_relocation, ventura:        "d555718239d6dd531372e6905d0410cca3aaccd622a361d64c061fc50159339c"
    sha256 cellar: :any_skip_relocation, monterey:       "43fc915929936b884e9883dd9fe2ba8b93721007ad63cee9a0ab1adfd37205f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b94aec49c9b1563d88b4f941939733c74bade22953221e99fb9c76e40ea1456"
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
