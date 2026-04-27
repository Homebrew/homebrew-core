class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "3799787f022b17be5b756b133d91165d20f83745a9b112934c7d616e42b0afcb"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96279e610516d1cbe581e2ea1c148ff03aa7229b884d2ed0b1819cc520d15288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96279e610516d1cbe581e2ea1c148ff03aa7229b884d2ed0b1819cc520d15288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96279e610516d1cbe581e2ea1c148ff03aa7229b884d2ed0b1819cc520d15288"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed3e9911a52a5d6642b22d1d109855b7d86652b78693b55a90395b35243ea3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e218539ae93508e80402db6c385fd37ad53df6147f360ef7306d1bf1a31e5147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a380b38a2cafdf0f03eaa36cce56127ef1f9f4c6407932ff8d5a409115bcebeb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
