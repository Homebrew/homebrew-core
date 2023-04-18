class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.9.tar.gz"
  sha256 "214260e7eb79f4e04cb4a00770483f645665536f72aaf8bdee28c4df4ec8b947"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "035fac0c94be1cce96c38cd8aec8928c187b13f4da024d08ddabb1e050e548ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaba195807ec949d6ad22bd2245ced67c23272d74e753e19ff04674e5f3f14e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a03f56193fda8217aab60a20e2865a60efe18db0a53dd0a17e4aa42d9f5fbb1"
    sha256 cellar: :any_skip_relocation, ventura:        "d155ae0fde6c114f111b0fedfec0445b8e2d1de02ccbfcbd25e31c106c899039"
    sha256 cellar: :any_skip_relocation, monterey:       "725697dfed7b5abacf9cc058a0751585013c8361972ed253f12c1c068b6993e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "123c54248de8d4f2bdd64dad2a61c1c3e189c453f5373ee2d6760787fb2fd9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b0fe5519b34260a78b7ec94db55c35bb725677b51fb3638c55d018b77fd4d5"
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
