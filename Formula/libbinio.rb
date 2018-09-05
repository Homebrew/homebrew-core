class Libbinio < Formula
  desc "Binary I/O stream class library"
  homepage "https://libbinio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2"
  sha256 "4a32d3154517510a3fe4f2dc95e378dcc818a4a921fc0cb992bdc0d416a77e75"

  bottle do
    cellar :any
    sha256 "09c61e01936f68d4f64648fa195150c8c7d82e0fa636e9f159687a293d5feab4" => :mojave
    sha256 "176f0a11a333240770e59ada053e1656081a324debb64b96afa942a86e18f28a" => :high_sierra
    sha256 "beba76f7c3b6c54228c8972cfa01d1cb06d309d870f23ce6aad457c23e11742f" => :sierra
    sha256 "a0e373df44eee915d0f9259fb8627df92bfe3db8547bf66a9918f5c398342709" => :el_capitan
    sha256 "99e8bdd47cde67290e0854c8854c0eef32a995ff10cbf1f991ca37834d60e0a4" => :yosemite
    sha256 "e4a0b854ab3f5e98362f19af214b909205240e8a0358b88b2adf3a68a0e875f6" => :mavericks
    sha256 "d01aa51c28a1750d04e88a0f9bfeaf46886b5898d1bbdfd37eccf1bef8d22615" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
