class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "43054fbe53922807d97816be802a39a9485c71369eb74f9ed2c2877dcb4d3629"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c929d2189b9f19416c04eeefa13d2107ea17bfe820581abd775b2d47346e3ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c929d2189b9f19416c04eeefa13d2107ea17bfe820581abd775b2d47346e3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "19bc3568f3bbdb2590d6982978ae71491c37da34858119bf1e5041381edf0f21"
    sha256 cellar: :any_skip_relocation, big_sur:        "19bc3568f3bbdb2590d6982978ae71491c37da34858119bf1e5041381edf0f21"
    sha256 cellar: :any_skip_relocation, catalina:       "19bc3568f3bbdb2590d6982978ae71491c37da34858119bf1e5041381edf0f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c95166236ddde622d40fc976c2cd5163aa660a4cd27f793a6c280dd50892183"
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
