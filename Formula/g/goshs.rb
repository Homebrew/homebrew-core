class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "f81de9403644bb6c37a212e495cdd8b12038489cc8cde1919dbbedc54a85ab8c"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b238f2c33e3e3a85e29a1b15bdce711e88260be8b54a7039e0b32b5a166d3719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b238f2c33e3e3a85e29a1b15bdce711e88260be8b54a7039e0b32b5a166d3719"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b238f2c33e3e3a85e29a1b15bdce711e88260be8b54a7039e0b32b5a166d3719"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bd75df430872a4caa60fdb4652626ddd62ae5819e150405d8b071ec18f0e5d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfae3755281c072a751b44bae79cdfc5b04877bb4ffc014b5c5df5c1b814b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79696fa85f6c88068e969be81ea80965a039cb8d4809e1b24925ccba1f334188"
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
