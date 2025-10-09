class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "60013650fc2c1cdca7e26f201751083de42ebfa05bd63375997135ea3ec0b871"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6237024376fa2d70123138447e0478b84d4ad0bd657e71d9a62a3371535025"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f6237024376fa2d70123138447e0478b84d4ad0bd657e71d9a62a3371535025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f6237024376fa2d70123138447e0478b84d4ad0bd657e71d9a62a3371535025"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d9251b8945a6059943b5b164f15424ef72e770992ab6baa6b34d3b83013138d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "772fa86e9469780673882e0f799740c594cb27cfe0a5e70e96ac53ff8ea81ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c78f3304e02847d276b825c014ed2a1d723301cff6592d7e451282137b3084"
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
