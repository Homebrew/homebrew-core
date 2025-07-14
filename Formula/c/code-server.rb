class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.101.2.tgz"
  sha256 "6f53a281ac4c2db0ea61f7f48d82e80312e5627342838b26a6127f81267b8aca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b17837fb2372caff6dc213558c18a54559d87d075ccfbfda507a418966cff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446b5b3a59f639aba664c835bedbd045d5d68fbe83dc90f198aba8a8c1642494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60dce0b3eba2d8d185269c39db158a75ce94601aaedb4d0fc95369f3ba94a6ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "a37a468ec4c86b2b400dda15140e3c6909d2d4c5ad98c47c54163203e5811256"
    sha256 cellar: :any_skip_relocation, ventura:       "29c209f66546f99ac44381fd04e97a44eaf4dd2f0fba2d377f0ecbd4b755e845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a4a8a6b5c3947425e218c23bd17d6d082a8463028e342b5db1a5535ce46267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848b70ca5e2c43b76e896d8548eb7626710ed0ec3ae7918d58ba5b2c05f413f4"
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
