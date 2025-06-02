class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.100.2.tgz"
  sha256 "869f21594fb63ef255b7c53ecafc4f5bcf973f8d1897829b6246341ad926f7d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8fe656adf763150a5900ec863e041e3d9cee4b4132f4a485dc27ccc3d720f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f1b17800fa23541788c0a4b2b564ed900f7c8ba8eb8a764e312442d10ffd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5234907d787f9631965e9d0d003bdafb0b613b6e4949a8658852524f09bdbc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b55e21a44a88bc6e2ef923ea2eca68d2abfd24d4b946980bed9567ef024e2d"
    sha256 cellar: :any_skip_relocation, ventura:       "08fbb86ce75941f8a3818ab55039a79f9948ffdae6d788c40388517c644ef09c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "601cffb081453ffec004d5797e208eb882c9e176c1e5cc6a5d9effb28d9c849e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320a3e07e323e30ff7abeadf933fe3577e8aed1a5f6f9c3d1a3e823ba64f68e7"
  end

  depends_on "pkgconf" => :build
  depends_on "node@20"
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
