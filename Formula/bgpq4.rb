class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.6.tar.gz"
  sha256 "7780d4f2fd2f7aeb53ec5378e6e6602124bc6fb7ef8b372590869b82ac29b2df"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d574cce3e95143b376d0033c4ef2522198115213c0978c69af880e8729ac0f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1a72d37ac787850262b0bdd8122371cd757a0c0714c354f512883c527636235"
    sha256 cellar: :any_skip_relocation, monterey:       "19a62e27c99778c6a9f1f658c82e35bd15b8f2bb9781346934362dd314ac2e18"
    sha256 cellar: :any_skip_relocation, big_sur:        "8be754e98ace729e605a777ba43c2c03c80e8c6b77dfca3bdd151b5f4ebe17b5"
    sha256 cellar: :any_skip_relocation, catalina:       "0c67fb9be427aa72a675c7aaeae678d3d7ab329463b55ec695b1c28d963f70a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11299a79113e484569173aaab049382f90886d66a0fdd26771c4de5de770034e"
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
