class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "c6cf492adb39e5438b7961371d037bd59365413f0f198b2a2b475a6a50a7f1b8"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32eb90e44d9e9f7d59f19df789b07ad86e02cd79dd9b7612ddddb2c207f6e5c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86e5b35cf47c1d10c3951e4f920d7016b15b78c88952b6dd48b044ab6137f5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7fe16663a4aa180081374a44ade3b271c1c61e06d9ca8320d4b5dab34b80335"
    sha256 cellar: :any_skip_relocation, sonoma:        "5acbe057124d44d95a25cd418ba2ad7e3345fe8f9f661567b27a885fe99db540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a65d9f67a7e5b31b685865134d15fd0f3cd4993cd2a57ac7b7eac82ade1ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65f22a10631d95c591d4c03b1a11993ea3f0f563556a8f3df5f4985e1242893"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
