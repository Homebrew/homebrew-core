class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "360cc2b9ca78db2d69ba5b45d09a6279bdf575df1babe306f21c3e619a591c97"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "197b160c1a71913e7fadefb1f74a492e605ff3827b4a292cfe04d5cef56d5d16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "197b160c1a71913e7fadefb1f74a492e605ff3827b4a292cfe04d5cef56d5d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197b160c1a71913e7fadefb1f74a492e605ff3827b4a292cfe04d5cef56d5d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "78bdd83902e82219bce4aa09984d7798b2632fe802c64c6edc1141c101ee18d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189b76042fd8d813a1acefc40e92b70e0231a5e632747b9a56213ed84326be16"
    sha256 cellar: :any,                 x86_64_linux:  "6d16383b0cf09fe3b95b9776e718739c92b6730b0c61e9f1a8065b8ead671fb5"
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
