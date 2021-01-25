class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.2.3.tar.gz"
  sha256 "6ca5d57c31269c4341ebccccfe94a9111dbb7636bda41ea3e7e8a665f61efa0d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "64501e027324a4f0a6320bccf181b820eb6107532db7333a4f4f0fca99757fdd" => :big_sur
    sha256 "f5f2d59d4a85c138bc94c4a26eb6be20c905b7d62f09387e80d3dbd85754ded9" => :catalina
    sha256 "f1e41724bff659405576e7b52b7bf37cce0bff432643e768d16ad221b7d4d938" => :mojave
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
