class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.2.3.tar.gz"
  sha256 "6ca5d57c31269c4341ebccccfe94a9111dbb7636bda41ea3e7e8a665f61efa0d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9075399347eaa3358f31fc12479838d334cad0bc2b6f64e12b208da8aa3ab751" => :big_sur
    sha256 "2929b884676303b658c622ec796cfac82afbe3fcca6cecc623477d3352fce493" => :catalina
    sha256 "47e4cb1ace5e7d36eaa204a0903fc8bf2f48dd58a21063201ae421511f949c3e" => :mojave
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
