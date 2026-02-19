class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "1a165e5dc6dd1f4950517efb569e1527a9d8462af2367917660711ebbdf5e5a6"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105f6868efd65248a3caa464d62c680e8fe393dec08db4fbbef10708849a8f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b145d488801fa17d4ec69474fc476abd3f58009382e066d8ebf1504ba04da60d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfab5b09047ac73122e3820db7d7518cbe333e848c41f009454ccb6e1b41b85c"
    sha256 cellar: :any_skip_relocation, sonoma:        "343cb3de5980a66c3700b983e5c519d7545de392a12238c14a501df64e99816f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238a0d845508fe2fe6e8ee1fe4bf9022c5b415448471a4ed3326bae152f27a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0604a3637ad708737f8fded6acd08ca62efdfd09564973382150a4d7fbddf7c2"
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
