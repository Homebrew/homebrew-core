class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "5bd02de1e6de40f2b31a066000bbb7ed30dc036f86729daf358300beb55f3eb0"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aac6d4c0d17f2e0e78a802ffb88fea4af629151e5cbae6ad37877fd4c7ef4b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac6d4c0d17f2e0e78a802ffb88fea4af629151e5cbae6ad37877fd4c7ef4b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac6d4c0d17f2e0e78a802ffb88fea4af629151e5cbae6ad37877fd4c7ef4b5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f423cd3bcc2cb5436832839309e94a8472c57ac96664a22a98e4365dd51e74fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e2e088be1109bfa317dbbe9400f03802fc17265aef713095153d35dea88af77"
    sha256 cellar: :any,                 x86_64_linux:  "344b57577698a2feec8e6819174d1cba977c3780d4088eb1feded8d53e6bc645"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
