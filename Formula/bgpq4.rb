class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.11.tar.gz"
  sha256 "0e5325633f607e00262a6b96d1d246a9d27b4b869bbcf582a46e8a43c5fa4e18"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5c9a1871de533c0d74a3052489400ced52e49e6e99475e258a6442e0a4041e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "417f0f9521bd293a97185c7f792987e9a4fb0b5d8b7a92b54b571f24a9658878"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31d0cbfc96c55a284a9532853d086127bfa521789c729a326bd5bb3408108411"
    sha256 cellar: :any_skip_relocation, ventura:        "3ffbdc6135d1e5a964933b27d6f3d46f576ae9dd797c0d14657b139c5b5703ca"
    sha256 cellar: :any_skip_relocation, monterey:       "7b5aa6a92d074e95581a838ffee72d444566e3a234060a5097933f666b725f5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "54aea55941a349a5f272e684d4edab343e99f955f295f80ce5ab7574ed0eb733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc9b45b4b4af4e3f171006c2d967907aa43bba2e9d024ed072f559493edbf8a"
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
