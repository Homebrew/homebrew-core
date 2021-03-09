class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.6.0.tar.gz"
  sha256 "33a28ce9630ba4fc80021c077086a91867f5af3578f70018b28621d4c7a67b11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3d0b4e12bb73c2ed504d81cfebd6cd32374388d5847a59a59367b1cd9701df5"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b2e9c5e7cf215752910878ab3aad22aa596dcbd2bd47c8b521395abae5814b9"
    sha256 cellar: :any_skip_relocation, catalina:      "1ac34b52b8fff225f804473e5ddf57d7ef5177e72a942a8a0264984e3ea1f16c"
    sha256 cellar: :any_skip_relocation, mojave:        "2479a4f61803209f070f6c5abd55ac5781aeb7e10d2e589aa5c4524cd1bd6bd2"
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
