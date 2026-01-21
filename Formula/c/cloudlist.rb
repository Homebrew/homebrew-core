class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4e44a8ae6f0b87731e8f411ef92521486b03535c3d83eb103c948a82382fdca8"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02cf10614473e0d90d5b6b8fcf75b83fded7f77827d57ff60dcb40eb08fb2127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885322b2c40445653eba730cc10fd391f27bdc71bdbfcc8f26ee01c25629a288"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a479f11c8f263ff2b6948327319ced818a67376fc4996476aa66889cee7dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cac162800822bd1de827dcc18b43944569de3a5efa28acb836c5e64e58b4876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad675df55e88b1e5e8407211f2ee43ed292b0eaaa228ff348c7fdc6f9daba7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fad4c35ef47c0687ef22c5f761e09fe5966d58c8e0fd98fa694771f51d8357a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
