class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.29.tar.gz"
  sha256 "2a1adf3381fbabd38ae02d64b9088a9ae740bd4b5542e8f06fd66be1d08d312e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6629db1e017fdccd2c71d9cf658bad2ae5ac97518185c816b6c904c2cd1876ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c4fc8960303bd2dc3fcf87a4f59d63c1d93535861d0852e61e2f34c553bb70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11a90b8727fbe34ae290231df9fa3dcefdda3c515616d7da672b30fc66478827"
    sha256 cellar: :any_skip_relocation, sonoma:         "20421f2e6a96b71a9bc7ece246636e98d0171c87314f0c6a67426cfe30e789eb"
    sha256 cellar: :any_skip_relocation, ventura:        "d2bcf1ae226be8cef8b2eca60436167dda34ef00334e9979d56ff2ca8ca5d7f0"
    sha256 cellar: :any_skip_relocation, monterey:       "50b3b962202dd6bfe18d07d1a65a26a19dd74b33ae1e7218793737779e165443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2910f56c5098b45330aee6cc6b78d034d372181f766cf9f31438a6e7e8b8da32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
