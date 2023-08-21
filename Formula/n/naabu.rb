class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.7.tar.gz"
  sha256 "231cb368bddea6152e6eadc83fc1c40a445282a698a84ef0ad3a4448a5c573f5"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ca328663a92a73f8233764a8ae4583495c6e96b732dbed8c8f03a7a6c5ce80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa327e9921d074a80edeae8615121a08d0378a6d00b53e409aadd2f1f5cdce45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a84b1003fadbbbdb1fcdf15099f883cbbca2620bef30b36492d771458e4e2d9"
    sha256 cellar: :any_skip_relocation, ventura:        "2e3d29262a350b6fd47a078b1d2ee7cc388f9adc0aea953b1cc4355ee8842c51"
    sha256 cellar: :any_skip_relocation, monterey:       "832aa488e7745e3652971e72ddd8ab6805f1d9df0e95f680428c4e9f25790673"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb9eabbde6c1a6fbf8fd384d234eedb6c5ee13ce9217a7cf62407738d118067f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b54fa2719dc4a34e9848139758d73310462ca26daa2bc0d546620327dc9bd0b"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
