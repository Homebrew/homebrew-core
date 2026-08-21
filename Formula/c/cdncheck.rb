class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.49.tar.gz"
  sha256 "8d1fc272c3e49eac352e6e166f7ac0fe9f71a34b63be219691198000ea1530d2"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe12c50e7eada527dc2a1a86e39216fd7d464476aa3655e462fd9af2e710cc79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3269e5cab1ed2f8112f713d7bdb1b69fb5fd68a82d88fd0a226fab23211c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9a4266ad91d60a1b77b1a0a43d6755cc528db8cc9e0cf295f49b228ce7acae"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9cdc8f799a2fc955c18caa2130d15c30066205bd32c9345e73d4859e734e3d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613dcf77662135bf50e791843b3ec8b53da7625bfb51e142ac72f246c80dbd78"
    sha256 cellar: :any,                 x86_64_linux:  "047d4c607fcdc963c2ea3268e87e46c3ed706e78c4ea16121f0a5e6c0af47dcd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
