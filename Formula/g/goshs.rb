class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/1.1.3.tar.gz"
  sha256 "f6b62e2161161c368538b0911c0f1ccfc16ce68d0531495ce8d1ffd4d9110a9f"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53a33b2135b2badf0530d5fd3ec4cc09d170e79cd8ec590174295f9327952b7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53a33b2135b2badf0530d5fd3ec4cc09d170e79cd8ec590174295f9327952b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a33b2135b2badf0530d5fd3ec4cc09d170e79cd8ec590174295f9327952b7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "407c85ce4ac2b51e2172e60523df14aea6d59bbea23290bc0503bd6f5b7532b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd11471619fc6e1e73f3e94a64db521b2dc0f76ba7f8df9ed516af0f16afc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89a25d370dd64cb1ce997d12af0de43fa5a074a5630761e6057824cfdc6a3dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    server_pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    sleep 2
    output = shell_output("curl -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end
