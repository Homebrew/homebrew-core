class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "c24ef4a9b1c0b416c1aeb786368b36736617c60cfd1f4e871798f5abb2a18e0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ddea1e70e7bc975a88822b896563ea72d2703694aa3ce81fc3b4670f780b418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd91be1777a87389d5d9f2850ee3bceaae8f0906a6884cd0ff5733f46cc33cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bd91be1777a87389d5d9f2850ee3bceaae8f0906a6884cd0ff5733f46cc33cb"
    sha256 cellar: :any_skip_relocation, ventura:        "1330b53a033055abd878d1327ecda824e690a515b8582d0044a71c0bd1e3ea3d"
    sha256 cellar: :any_skip_relocation, monterey:       "9d48a5cc2914124050be0ade5d8841b0e18e90d189bc7ac122b5810a93b5e3c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d48a5cc2914124050be0ade5d8841b0e18e90d189bc7ac122b5810a93b5e3c9"
    sha256 cellar: :any_skip_relocation, catalina:       "9d48a5cc2914124050be0ade5d8841b0e18e90d189bc7ac122b5810a93b5e3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352376c7bf732d44be40afb5db178dc95697eea7e949511e0d30a6df304ec58f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
