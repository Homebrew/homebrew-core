class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.104.1.tgz"
  sha256 "de0e328f385e54a1a0af9b1255e1a8e52a63699a04a3707ad6e3b20e6b00747e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49df53972866ef28ddedf15cd85dd6078c4c54b1f729ea4cce50683435b4aea1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34b4d72fac647dc2ab52df956743347ed1394eb69a89e3d743626316a8555cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a5683c156bd1ba02c7b41ad75213a1f5053fa05c56f13d303d5628bb8f8359"
    sha256 cellar: :any_skip_relocation, sonoma:        "69dc5b4971beff29fb63f4f4e52c4a1838b22399e9a8002e6a53e5221873c39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d76dc751bd0f4d7882d94108df3eae736a98ccfc7be33d8824b650062c29c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca3b06ce0f4c541ea963bb8ce03bcb6c57a2a5083b8d468604df9dd4a13bdf2"
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
