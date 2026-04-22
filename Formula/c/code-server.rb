class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.112.0.tgz"
  sha256 "adca4415d5553e9a70ef755f36f6de944aa2d9180540ff42d899eb9ebe28d8c8"
  license "MIT"
  revision 1

  livecheck do
    skip "Newer versions use non-FOSS @github/copilot"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f7ac4b3e3fe166cc6d861b4135796fdb9d2d30fb1b29987b50418b4a4b34ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8487c2ddc85086993dca155ec5b946c8289592351ca6cc66ef607bc7be99c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d90eca0664540b5eea48c3034340b25bb540865d2d15a2f21d4b6ec9d391867"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd87893ceaa9ce6ab62becec31584422c66922ae417b4ec7abc422d03260220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3577f8080904eb450dbeb2f677e7bce9c85ea2e926475b91d9c6dcf49de112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa73f90f44342fd3e122986d843ae4d3de1e735ae5590e292ed18516b240cb4"
  end

  # https://github.com/microsoft/vscode/commit/98f15b55eaa9ec24b60cad2905d53f721ad67357
  # https://github.com/github/copilot-cli/blob/main/LICENSE.md
  # https://github.com/github/copilot-cli/issues/19#issuecomment-3335871033
  deprecate! date: "2026-04-11", because: "uses non-FOSS @github/copilot since 4.113.0"
  disable! date: "2027-04-11", because: "uses non-FOSS @github/copilot since 4.113.0"

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
    odie "Do not upgrade to 4.113.0 or newer!" if version >= "4.113.0"

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
