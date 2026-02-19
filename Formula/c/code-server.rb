class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.108.2.tgz"
  sha256 "b188d4da150211b510116619daa8c21c4bfe0a21b5aa41910b8acab60304d4f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3f0ddd6eb6c7fc6e35ef4b30a7a317f500a19b7e56d704cde86286111b6e7ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476a01757451165df7af02da5b6fb9fdd913e3756fcbadb1bb8ad50a44031b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f8fb98c626f25e30e71f58f984d43693d266c1ac34310f1f9deea064d22651"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c6dbb00567b9dc10ff44fb43a243111470b63b6eced2ce13b6b4c8c0581fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c32cfedb24e730cc73a279e8089bfd9b5bed49285b7ddb313ac631732eb9a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed63830bdd367a40a2d077d820c073078b4839383371ae749bad43487f718e21"
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

    # Remove pre-built binaries which are unused as a source-built binary is available
    rm_r(libexec/"node_modules/argon2/prebuilds")

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
