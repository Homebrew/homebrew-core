class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.114.0.tgz"
  sha256 "0b7b14a267db634b7c3611ee7869998370f88cd668ef0877eef58a7e3d66e401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c942206b830ef64dc0513e0b589fdd1d676daf7430121c73d0530c998d54990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec49f8dfc8ca8a7e2546b66058e99e341491100cc9fad0c9d1f03880e50b5bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad61fd8260520cdca936fceff2180d0c542d79ba4f4d2a5e670da929a95dcac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce638cfe849542bb6700f1ee9d69f23e9da5344114685de1966d4f28cd64823b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b48c262215a178bc461781fc18d385ba906a6fd8cd58b0d7e30319ef8cad97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49514e85f16edef9f5af5820ffc1896edc5dade9c2405b19d9fa0c5da4271426"
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
