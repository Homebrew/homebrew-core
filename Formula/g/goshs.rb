class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "ea521af316dac8acac4a98c977b3d65400d9867ef36008ea3ecd1843c09555a8"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a30e570cb2b179fcfb163bd53ff2f422a99c4e86565bb4e3e2b3657b9f6484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a30e570cb2b179fcfb163bd53ff2f422a99c4e86565bb4e3e2b3657b9f6484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a30e570cb2b179fcfb163bd53ff2f422a99c4e86565bb4e3e2b3657b9f6484"
    sha256 cellar: :any_skip_relocation, sonoma:        "c92c7b62617c11e5ae5e372fe98d7dffea0e387b16afa2ae9c8a4846d51edd5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3a84ab88ac2469ef4fba85a7a307bd13b65f5f61d42aa454965bff4702eb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c146f4c3a51221294df1bdaea052661a5e4679edb5a28b825c73c5bca5da65"
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
