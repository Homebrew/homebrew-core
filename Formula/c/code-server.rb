class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.99.3.tgz"
  sha256 "565b30701c077952685d43ee2d4681fc454f85361ca7a7709dc71dd6fb5dbbb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876c279e3b2581743f5a083428376affc5b34a6de35944a1fda463b81b3b7e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a861c6ba0673f59db0430de52a877c737e98cee5f8fa4024238f79ef7d22595b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f79f3a584f819f4733c4f39b2b75523fee39b1c96332d92e40a8f29d1656a5ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "0928b639778faa2de2ee2088867a3020f936ea39f46142b3f05609fabd021420"
    sha256 cellar: :any_skip_relocation, ventura:       "a2bfad7e2ccc04b3628f72438636e79d6dace360c3371312a91b52514e43c02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8963908279f02b3dd53d97900d0a2e15a3db15076d7ddf721486cf9004a1f684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c0739288d281cc8d4ced2ef5cc241c48d16985c3ebdf80d63e85f37f876124"
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
