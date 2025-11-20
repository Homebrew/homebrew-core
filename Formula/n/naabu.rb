class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "1813bc2300eecca988b8d7b36d7f48362f90abe2db4bbf4c55a131d7a91f689a"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a4baae705a70a95a0b8371351a452359d558e09970e6f46a14ee751ce66792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d1cb7e0940c574b69153f8426f7db86fb7e2cddb3eb81b82f71781ff9a59a10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7581baab9d0d6244b932952a33440ccb4281b838cdc2a02d2d043cc409abf0f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9ef37d4cb94ada01d73dd864707319e107df41380a45dd55644a9c2ca49067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eaed56615edb7c88cd09b7278315abdc2a05dc152013cc37e231c6b37657f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff4118a530f730b123ef205ee9821635f949df807bd26ff331c083e8b46467c"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
