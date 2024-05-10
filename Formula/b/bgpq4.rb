class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.13.tar.gz"
  sha256 "7c38447fbf3c6b6856899bfacc2433018c93036cc3690064b1518511676966ac"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e89ece287d0aff9ceec7eb41ddafde822c58a3e6d5f548dd6e8be924f83bd71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9774be422f4e8ad53b8099ba36dbccdb651ebf86523347ec1cb143dce66341d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d78bc564b3889a850055b0c2bff16261b75b197dc0a4b3009ce0e3092293ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "78a9d9c4b5449674b7da115bfc02d3b2a990d31d32fffa44e5de87736ecc239d"
    sha256 cellar: :any_skip_relocation, ventura:        "844308fbff5c88e074f5d6f3dd23cbbe0a2f4c5335e8f983880c06dbd86467f4"
    sha256 cellar: :any_skip_relocation, monterey:       "2d038aaaac4a4cf42bd7952a9b9859cd8a1db13e1bf53c3195dd0a1e4290fc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "defa2e246bab55080bcdcd7ca923fb48fda70632641db51310ecb1b927084b09"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = <<~EOS
      no ip prefix-list NN
      ! generated prefix-list NN is empty
      ip prefix-list NN deny 0.0.0.0/0
    EOS

    assert_match output, shell_output("#{bin}/bgpq4 AS-ANY")
  end
end
