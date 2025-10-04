class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.104.2.tgz"
  sha256 "7dee94db07a592743d7ec158e47281b1f35b5b5982f3e4288f252254bd4a3dde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17ade831ac49409172e28a6cb42651e4b693c9d23d5958d0f471b0b508df2d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31a7835370c15cc9fb06d61780ea226ff85a047d0b2c3f9160616bfd50f63790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3410e7c02e2dd5633984f22434f8a474c005dba89094da8ec5fdfd3aabb74d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "8de3547b09c1911d575b6e32263dfa8b4344014b41cece4917c41214d329ab74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b4d1f0bf21fae61aa9cbb8568b38b8ae356e520c318ce03c5fdc135a695bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4283efad1a620df3f80496537f0b7f4c97915e6b261cea6dae14bdfa7634138"
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
