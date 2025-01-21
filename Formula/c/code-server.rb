class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.96.4.tgz"
  sha256 "dc6cbaf3b1f1ae6987a210bc4e2366f0ad16c6eaa9b89bfcaf54fdb54dd30b64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18aa3fe12ef3668c2d66d993148a001798db61c5c58c9e3859d378f3008be5d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc467072d70d24666284f8ed93360f8f2d49646faa6cf99496169f188581dfbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5153f4abb8362807fbdfb3ba3f363a9da90e5a541a209687837d43f2c9c7d773"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d834ed656209dba3f041eb33a2dd34cd62ba9c672233157bd24a95b737c7c9"
    sha256 cellar: :any_skip_relocation, ventura:       "112d61e0dc802c8a7fdeb590f76178a733fc7ba0f37181d643b2b47c5446e1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ec2b8b3abf2a6e041ca0f4d11936d778b81752d079ebbd8ce8875028875f39"
  end

  depends_on "node@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
    vscode = libexec/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    vscode.glob("*").each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    vscode.glob("linux-x64/*.musl.node").map(&:unlink)
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
