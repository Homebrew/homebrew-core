class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/0.0.7.tar.gz"
  sha256 "c39af7d2a8b0f4cf61543e776677baaf067aa087181851572211d168258f7f9f"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a5b6d4d65725eea1d40ed0192633d2265eb9011c5e7df3f3d2cfc33b2cb673c"
    sha256 cellar: :any_skip_relocation, big_sur:       "80d33aa9cb61cd994b2322d2709e7cdaa56887f0c92c8342f6eed501e78edd66"
    sha256 cellar: :any_skip_relocation, catalina:      "0e49b63edcd89b6eab9c979ae6e8da2f2ac30d0bc26242a1db2cf2d0233441ca"
    sha256 cellar: :any_skip_relocation, mojave:        "8644ec33178ee7e9b4b1293d77273c0ddcb11d6e4fa3aafb4e051af2dc4a5e07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
