class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.112.0.tgz"
  sha256 "adca4415d5553e9a70ef755f36f6de944aa2d9180540ff42d899eb9ebe28d8c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9beab2b9faf342dbaa5285e28769f15cbca0fc7a49974eee7d55db4473e7b5de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5925f52f54f5c9bf28e282bb9e2c44346e0847944eb537a668b94ad50bba68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe6869fc47d058252388cb1aab5d13ae038bbeeb2ff414564a36a0fed0c2c48"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ccec1a1431856575a4a0e896005bd7b3e51d3deb47be0a501b9a8ed2c068e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef1cecaa8687d64eb3e46272f9c267a6d0d4d540f844b1b21ac8f8e87d7b1bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037207fb5db01520481db8969a8d2c2f5ab989ae0a2b5108e96ed0847ffe6fc0"
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
