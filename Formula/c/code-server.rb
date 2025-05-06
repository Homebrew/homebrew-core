class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.99.4.tgz"
  sha256 "abbce6f8113b9cbde0178af40cb58381b16038c79cbca2c5bf1f244603204fc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bdd0423fb95f932fe06de37802038f72d242f151d772ae86e00453b939dc03b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e1458ceb0a0eb554469d7da84c0fa3ca42b76e0094071f7e2c98f014e20f4ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "757bbaf56a66e6a92d6ef1a36f8c4c07757a4d50daecb1ac9d615c21d092a6be"
    sha256 cellar: :any_skip_relocation, sonoma:        "61770851ab3cc777ec2929f027d74707ec30288c90672f839926cf772f4dbcd9"
    sha256 cellar: :any_skip_relocation, ventura:       "f90722f53235c60a22cc524a6770cfcab91f75ccaaed01ba77d28886a3175431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f99205ea8737706d7bd4353359ea66999de0db36d766a743751c50c501e9ecd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6222827901814a590f86e2fb7ff89ec01a2c062000a65722bfcaaadf956972b3"
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
