class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "e4f67a2248a87101c4e4d28180b7d707f12cad90070d9687ad2411e7f25e32d9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1fad1026bd4816fbe670c06d0c0445a5783ff6b930ff8b6afbf85eddafcfdb9c"
    sha256 cellar: :any, arm64_sequoia: "d143a2b171780859059ca9e04facc4ace2fcc3d2b1897137f10c8a5702b0e9b9"
    sha256 cellar: :any, arm64_sonoma:  "048a3bc89f12d285d5bc51d09d29290792e0a94643345d1ce0360a6754f5c0cd"
    sha256 cellar: :any, sonoma:        "7fa9ffd2064347deb33779a5fc904732fea36054aa6ed3e3bf1973a01baec456"
    sha256 cellar: :any, arm64_linux:   "dde6a18c5092e9993a374c968098935a8236fc7d40a66b6599284c56e2ec0844"
    sha256 cellar: :any, x86_64_linux:  "b9b6ceba6d4e4cb1267db375c17d43efef594db4e5ff9c33587a32a883088feb"
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
