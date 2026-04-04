class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.113.1.tgz"
  sha256 "2f90cd3a574deebae45f6c8bae8c13514b6142a6e219bb00f98038a17912bab7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8653350ed2e757ab63d8941055903aec0957aef4f6c67b9c4e65f63ce7ae1910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd0a8e88f16203a2093a3931401617cb96a9ecdb763025c35d3787c95d20a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5d09f9c9454d1a55fc5e802eecd7a72d069f3112d5974d6f61ec51c135cbebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d97bfb4234bc05b7716e6710133f1cc0d3f98faec4218262418f71f41750718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d487c57dbd3e9d3cd7cb6f7f5664950f851065f307bfe7f04342d9be31c4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a18470494c03d290ef3aab36bac4b4431a8e3dbf47c5d60adb70a1e00105109"
  end

  depends_on "pkgconf" => :build
  depends_on "node@22"
  uses_from_macos "python" => :build

  on_linux do
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(ignore_scripts: false, prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove pre-built binaries which are unused as a source-built binary is available
    rm_r(libexec/"node_modules/argon2/prebuilds")

    # Remove non-native binaries
    arch = Hardware::CPU.intel? ? "arm64" : "x64"
    anthropic_node_modules = libexec/"lib/node_modules/@anthropic-ai/node_modules"
    vscode_node_modules = libexec/"lib/vscode/node_modules"
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/dist/vendor/seccomp/#{arch}"))
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/vendor/seccomp/#{arch}"))
    rm_r(anthropic_node_modules.glob("@parcel/watcher-{darwin,linux}*"))
    rm_r(vscode_node_modules.glob("@parcel/watcher-{darwin,linux}*"))
    rm_r(vscode_node_modules.glob("@github/copilot/prebuilds/{darwin,linux}*"))
    rm_r(vscode_node_modules.glob("@github/copilot/ripgrep/bin/*/rg"))
    rm_r(vscode_node_modules.glob("@github/copilot/clipboard/node_modules/@teddyzhu/clipboard-*/clipboard.*"))

    # Remove pre-built binaries where source in not available to allow compilation
    # https://www.npmjs.com/package/@azure/msal-node-runtime
    # https://github.com/AzureAD/microsoft-authentication-library-for-cpp
    dist = libexec/"lib/vscode/extensions/microsoft-authentication/dist"
    rm([dist/"libmsalruntime.so", dist/"msal-node-runtime.node"])
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
    assert_match version.to_s, shell_output("#{bin}/code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}/code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end
