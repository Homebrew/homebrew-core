class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "d9c86b001e63867efc3bd30f94cc077bdd714f605e33c5817292cafe84df7653"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "689f76b1d84d7dd6c892ce4afb8c0f725ddb96561fb7b11db684ffaaf3f09460"
    sha256 cellar: :any,                 arm64_sequoia: "bb8f970c45a1ae1f1c2719282765cafa91e7a0a3d82f0a20ccdd2f5b6c327858"
    sha256 cellar: :any,                 arm64_sonoma:  "ee5378b66d66edc29d39bc5908fd39dbd9519b7dd6c3e5c39912b1cbf3f765b3"
    sha256 cellar: :any,                 sonoma:        "2fab45da5e3a7760aaee6813217dc7d7b3b94d5582528f2cb52fd228ad3980a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4ef5785d0a5de94743f0061a9fce176b82ecb499f4914306e1b2f84d5052d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1a05810d776ebf29972c9a4891fc9fb81ff5ae0a33579ba306d8dc893d3d92"
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
