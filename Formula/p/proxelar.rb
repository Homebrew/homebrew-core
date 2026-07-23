class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2675e32a3e9a21b7ad077687ac4e2282e8318fb756b29e0796eed2605418e0ac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f409b92d33b3697f0c8cd6dbd3063682b6100507eafa968909dd09ca845c0061"
    sha256 cellar: :any, arm64_sequoia: "1950635839ddb8568986fe6473dd2d1e01d53e08424e9115fe89f9d3631e345c"
    sha256 cellar: :any, arm64_sonoma:  "6fec761794104a91210a0918b66f2388f15c01d5109c2034f7257f5ca402f463"
    sha256 cellar: :any, sonoma:        "08b9ed96f3b91f5d33345a66cf6a0ef09223eb6255dbcde3bfdba778bf473f65"
    sha256 cellar: :any, arm64_linux:   "30d0c8175b9b7af47d64d23c0009aea0a74f6bd83104da227e6067921d2dbc45"
    sha256 cellar: :any, x86_64_linux:  "953828255d47e6e35fcb3518426fef8aa77c19eb0d12e20a9c6c2b5d36ec6840"
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
