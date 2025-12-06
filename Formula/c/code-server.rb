class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.106.3.tgz"
  sha256 "dad08be179fb250519083e93aced32323994c0f44b5835c69deba65006daee4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7d37405f4f545794aa26762ddd55d82753f413ffd8b16970d87db40d70b154a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f17e3c4edef4d80217522b0deca5b4f2d6aabd452e5afef2535ab17b606ea269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50bff17a9df4ac62d8ea5a75f5445a62c87aba5a490545fe169a18dc7effb36"
    sha256 cellar: :any_skip_relocation, sonoma:        "37884831aa2c16cb72467e6d49b1690ed9841560031f18992b4bc52db055a2a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63f21c379470c3bed9eeaef89ecf9af6501a017b77e31830b439d7bc8775142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c75edaa0709c938ddfd327736dc6a7f422fe810978268a44ac41e1df3dc8d7d"
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
