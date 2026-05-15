class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "cc5f99c7ed7bbf3fba8c133af194ca4f90709504989a4130f01a7f343e447563"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cca07c4c195b1ab7712826c55349b02e849dcc59c4d60d0f19a7795be509299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cca07c4c195b1ab7712826c55349b02e849dcc59c4d60d0f19a7795be509299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cca07c4c195b1ab7712826c55349b02e849dcc59c4d60d0f19a7795be509299"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a8aa7335696fffdb23620139074fff46033770bbf5360e44e4bf47e565b7e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8642428457038f7e0df60ce40c479965bbd19a9a551e0c3dcbbaba99a786e55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e596cb42f36adf3b2e2e265a054aa4454ce368d5952302f22bc41b257593c24f"
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
