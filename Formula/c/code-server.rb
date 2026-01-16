class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.108.0.tgz"
  sha256 "e82ae4d2a2dbe0985f4c9838e4e79d3f98b9356a8adcc1e07f2a691382402cb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb64bf27745175d5107800c3e3f0bbb764295e471f167ccd0b39a1a1b889dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "add7fc5e0398b4ccf11cba57ec08583cbc58aeb05f623045db303edff8292eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "005482312b1d4fc98740611e9863e332fde709500badbceedc68745bc3de0e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df1eefca1a20496238b26750be886e7c44f0571fac62e1e90fdb093553384fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14cbb04ddcf50babf9b6dc9f8be8c78a20bcf7a294c3bba120303baaa775a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab48df518afc650f8a6d962b27a2380af4506bdbfb6f44e45b0f8ceb6c212b8"
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

    system "npm", "install", *std_npm_args(ignore_scripts: false, prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove pre-built binaries where source in not available to allow compilation
    # https://www.npmjs.com/package/@azure/msal-node-runtime
    # https://github.com/AzureAD/microsoft-authentication-library-for-cpp
    dist = libexec/"lib/vscode/extensions/microsoft-authentication/dist"
    rm([dist/"libmsalruntime.so", dist/"msal-node-runtime.node"])
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
