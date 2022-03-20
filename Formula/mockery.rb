class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.0.tar.gz"
  sha256 "a3dcfa1f0599858bbc3ac1cdb17a09702ce0236fd329ddad80f975b8ee11efd1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1b26d9a01a32f68d8848e26a3b2e6c8441164e4dee9ba57b5cfeb9c7d143d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cf12466108fa5009e463bb89771e85e0a6a10d50058cb1fd3dd7d16577ae027"
    sha256 cellar: :any_skip_relocation, monterey:       "addd15aa97afb69c5fd9a465e69951e2afd2d3769a449e46289eded0a00f256f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a66120fbaff7d926d3db6187299b21469d3488a40ebc5206f4149ca909318e7f"
    sha256 cellar: :any_skip_relocation, catalina:       "1074d77c9a6b53bccb53437e9909c842dd6f9dd55b4255916150ecc746c1fefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f67449331a23eef1ba830dac1576504470f73bcbf40f42a022ec7127667c8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
