class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "c56910819b2f1f69691a2975f9c15a2df1d9139ab0a73843c43743d31fc73157"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef9437264b5958a8ea7b39baceed3008bd20b9bd73c3e810eccb55a9cbd39197"
    sha256 cellar: :any,                 arm64_sequoia: "96c73c5e36e53005b2af69809c9aebc20bb04c23a2155937d1a6d6a7bad116eb"
    sha256 cellar: :any,                 arm64_sonoma:  "9741b8c4643907f916fe0f276696cc36918e8fef3b44a0fa5a84836ce815b5e1"
    sha256 cellar: :any,                 sonoma:        "d5ec0377dae210ad616dfa0a85ed99bd6deab32b1612d69b46691d1b9b2d6357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40a3b7c85deeffc1d5eaa1ac941b933a29fbb9fd79e3a66e56a334c0350e058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f9326665c9f8eac83ecda03858d44431ef47171ab812028845745a79f5f6ed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "proxelar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    pid = spawn bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath
    sleep 2
    begin
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
