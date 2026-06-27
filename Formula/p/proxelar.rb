class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "592edd0211e594de5b4af0c456db7e72fcbd1290f6b552b84a2cc80e994acfb7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "871f620f3da82c0cadabc466b32dc450408a54743989ecdd03a8afda7a404a1a"
    sha256 cellar: :any, arm64_sequoia: "9fa59540414a5f95e208151b59398877fed76149bb1318fa6d8cc57a6a766bba"
    sha256 cellar: :any, arm64_sonoma:  "0881cc5d3dc83f113ecdbe0b521e6dd7a12892f5580db2e8803d6a0076b635a6"
    sha256 cellar: :any, sonoma:        "f3251779f6a9ea211b888739efb78ee2c107ad465c531570bcdd5a2ca039d4f4"
    sha256 cellar: :any, arm64_linux:   "621b612f5ac601c381efa573ee9d1ef95152d619b447978d934510d0f41c21e0"
    sha256 cellar: :any, x86_64_linux:  "7c171dc9c5221fffacc3e1a9bc61ef7e67a792ef9051a449f39124ad69c03c68"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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
