class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.9.tar.gz"
  sha256 "94332ed48728e59f9d07005909aa65d9c99ccec9914447710007ecc08553cad8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0ffadbd7a9fa190df7d30d7f21b5c679f32c432971f72998c9d44b361ecaf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1ba71099d35d325493bdb86a7f57d9c956838d0eac59595678d1381d751f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c66053af0ecf2cd624c5429283dd4a607a46eb2d726c3ff6e8c1af21232cdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3021f7a02f54b1d5ef8e31b483402ac570eec6b2c2c1b697fafcb214ac5ef3a1"
    sha256 cellar: :any_skip_relocation, catalina:       "7b84929ec835cd33321dd8db397feecb80ab61e2db47262d5b5b493c50f23f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2ec8aa862fadc1004f6f3b12afbf0e4c3b52a283d4ab13195a37310f304fde"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
