class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.99.2.tgz"
  sha256 "2d242da43cdec0d2c71535965528a6435067a6d38a959e1962f3e6323bef51d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2951e82f4e58f3828c2cc410bd41671adc37b0d3391eb00599d5abc6d05fe19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acac0a2104a84b762de5c32a78086943d77c263cc06dd51da0c648873e4330dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ee3b5b1159c7f9a739ce61b2ed5da9fc9d30f76c5ac22b52f52918a4f9e62f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "298a267ca5cf6b9fa90c0056d0787d5a973e097f9aec54f1dea62c8438b718a6"
    sha256 cellar: :any_skip_relocation, ventura:       "a9ed6e659b63c60e6a199bce74ebf03dc26dfb028318fadcca24bc84b5629dd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f51ddca93d2eccfb7c5e35c642075dffcfaeaf09c12d14b4982342942646bb1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e5b3b0c6fddaa3137b30d86cca9960705eb5312108186e427bc5462d8c659b4"
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
