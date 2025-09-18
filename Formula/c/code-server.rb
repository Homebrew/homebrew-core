class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.104.0.tgz"
  sha256 "9fbd095b6ca059c642dfa6f59868d813b524c5fcbcb9060c53d1f92c66fcef7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ee4236c5d7765ade0f3e9bd21b1cd0181dc47b811f0c1fda3e7b532400f2ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c091f1a08972088d3aaf28743893caa72fefba6e486e6a280df87076490760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea089cee0f391c0b971671b7504eaadd8e1fb13e3e8de357c71574d210d01bfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3a5d70c6b643c4fbcae0af00eccf2baea53e3a2d02bb232bd1f7288f87618c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e5eef1384176c777834dd14d8c741c57de77e4be9a1685cdfd88631da407db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64565b25b3f54dc6b8f1f89338157c8574e19375c9d8efa60d6a63e21ebe8d2"
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

    system "npm", "install", *std_npm_args(prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    vscode = libexec/"lib/vscode/node_modules/@parcel"
    permitted_dir = OS.linux? ? "watcher-#{os}-#{arch}-glibc" : "watcher-#{os}-#{arch}"
    vscode.glob("watcher-*").each do |dir|
      next unless (Pathname.new(dir)/"watcher.node").exist?

      rm_r(dir) if permitted_dir != dir.basename.to_s
    end
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
