class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "b35856253e6d8e5bfdeb7646a24cf23dadda1b3a6e3d05ef49e4c9d15d20ee3c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "84b8fe7b6346759c6f88c6fe587bdfe18c4a5d105230c9014367f94bb96c1a4a"
    sha256 cellar: :any,                 arm64_sequoia: "10bbc78ba15baabca0ece294d9427c33582206eb99c0c7ac90f0e59efb9fbfe0"
    sha256 cellar: :any,                 arm64_sonoma:  "4839bac86d126d9d8d3c2526f7d86b4e2ff7af109b2dd0066a5bec3e49b9d7eb"
    sha256 cellar: :any,                 sonoma:        "449c586d869b46546b7c9460b5fba97de8ea3b4f04dc7543a07bf3b766a2d8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33a46cddcdba2f3e6a1169ce180a29d15dcc10ea6c59fcd7694e5fc85bf93347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d34ca05ac9c1173463e2da7211aa7e2662b49ce27df5b33314915e0fc80939f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
