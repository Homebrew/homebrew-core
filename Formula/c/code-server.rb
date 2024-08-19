class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.91.1.tgz"
  sha256 "caff899580267b4020c9cde70eda1f0d465f6ee6c134177ad4334de783918ccc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6552a8d502d4ec0449d6cf7fe11850a49e8e6d7868322e4111534edc714f17cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d98325dd95798edb060b780660b45820c14157c17d53b92a2b5cd49603b8d864"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21d1c6efae8b0465bbcd83dcd56abb4d43764bb702334aa65aaa73d81edf2ca4"
    sha256 cellar: :any_skip_relocation, sonoma:         "592294a1a8feffcea9f4500337ef9eb5132024d0347c28ccb457d49e25193961"
    sha256 cellar: :any_skip_relocation, ventura:        "3cf716bdda8bf22b70e15b036984dc8f2d86cb269f5a52974ad0c7e2b45b53fd"
    sha256 cellar: :any_skip_relocation, monterey:       "2da8171b6ac28da15ab8601baddbc17f01461da314fa2a607c8fe1fa416f8f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118464890162921266db09f853b3798af699af8519c9badc11c65db8ced8b6f6"
  end

  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec/"lib/node_modules/code-server/lib/vscode"
    vscode.glob("{,extensions/}node_modules/@parcel/watcher/prebuilds/*")
          .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    vscode.glob("{,extensions/}node_modules/@parcel/watcher/prebuilds/linux-x64/*.musl.node")
          .map(&:unlink)
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
    output = shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
    assert_match "wesbos.theme-cobalt2", output
  end
end
