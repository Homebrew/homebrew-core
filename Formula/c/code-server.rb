class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.108.1.tgz"
  sha256 "489087c7400871b096acca94455b2452fe3dc854141e47e62b3316f9e7cd7668"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c816f5a0538d4b153652c8ad2dbc64ed0c940ccdea0d2324b6c3ae502e640fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f0f2fe5b282b8adabf1332623e4db56e977ea59962c18a60e34650a37af1f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34a561dc2c5f6af232a4a41e5fb19ec44746e0231dd5d9ce698cc5d8474c557"
    sha256 cellar: :any_skip_relocation, sonoma:        "417efd2ce3c593f2bcf4dddf71c407fb61ee0b6aff7a398c1b579d9b2402c6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95c29a0defac05254d2ab606317b6674fc48eca299641c7b7b83a77eb0592e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59229dd3c3b56c21f4f7a8cb19f933dd2993b157280d2e14f2678b31e6b23184"
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
