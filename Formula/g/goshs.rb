class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "fbcf87e7b6463d6273ac48693791c01d24e7c69360359175cc6e5c0fefdfb7b1"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1ba25c7326946d5c14799a3412b4ced2905f634afbacf4e428d5ba2da2f7c33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ba25c7326946d5c14799a3412b4ced2905f634afbacf4e428d5ba2da2f7c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ba25c7326946d5c14799a3412b4ced2905f634afbacf4e428d5ba2da2f7c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "c20d92d01db1613c51b98ff2f386b3c8be51c9de942096915a41b26bde3d9671"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce54458951a4f87bc9bbca25c509671d5492cd795d3cdfd41382d3d747569367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b7157599f8f96c428d809f80fcd62fd280023d839749303d63636dfc5e4017"
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
