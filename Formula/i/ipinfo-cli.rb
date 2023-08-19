class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-3.0.1.tar.gz"
  sha256 "93d494510e903c032b9081ce84df3d97ec765d7e297b2b7bc7633606f520adaf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "246d9b3e442b37d51b48eeaaf875ad18ac101b72745a7896354e879714564356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d3d00fec025d292fdf19a8afe7970cb4994b2f7ad922d4baa4afa10d2d8b0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a2830c6fbc96497b162ee64a5a7fd7e32fa0e247090978f4d5cf412d23b1dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "c4a99325bb43655f6c231a42844a73b622f6ddffde4a573f1eaa9d8516479240"
    sha256 cellar: :any_skip_relocation, monterey:       "57e0ee5f555cbee5653fdbcea3dc392c5028f31644b72327f07ebdad79f91b4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "64d840f6e6bcb5a626b353f002025738960e0019126747af6342197437387582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c923f1d92ae959ad41a1901ca4395ecee9df2e0af1913fd1b02b898863c8714"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
