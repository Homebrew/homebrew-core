class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.6.0.tar.gz"
  sha256 "33a28ce9630ba4fc80021c077086a91867f5af3578f70018b28621d4c7a67b11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9dd419bfb397bfa5039b9ce3795fed9ce3676c35619f46fa8e711359221fc483"
    sha256 cellar: :any_skip_relocation, big_sur:       "7787c3081a951a5153504c27646b4272e0cee36ebe1c9c5583ad08ebccb6744a"
    sha256 cellar: :any_skip_relocation, catalina:      "86ea68f9ab7c7fbf007e4aa5f03f1b75ff9509b773274c02127be38d745802e9"
    sha256 cellar: :any_skip_relocation, mojave:        "a79c09d1ea891798b4cf978e47efaeb03801e6370d7f38c98012a2a8eb6460b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/cloudskiff/driftctl/build.env=release
             -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}",
             *std_go_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
