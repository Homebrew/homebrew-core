class Libbinio < Formula
  desc "Binary I/O stream class library"
  homepage "https://libbinio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2"
  sha256 "4a32d3154517510a3fe4f2dc95e378dcc818a4a921fc0cb992bdc0d416a77e75"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "242943ef59b0240db7e61f8ba587bafcb68f080d66dea8b8bb461d2e292fdaaa"
    sha256 cellar: :any, big_sur:       "892d24b5664bb470d0b90f714b4d2f9d8bc9bc62f857f003b4736bd5efd9a5f2"
    sha256 cellar: :any, catalina:      "9557b784c8c13985e1cbdf62fec7b49fd85766c82c2a3b01a4ce4596f36249ef"
    sha256 cellar: :any, mojave:        "09c61e01936f68d4f64648fa195150c8c7d82e0fa636e9f159687a293d5feab4"
    sha256 cellar: :any, high_sierra:   "176f0a11a333240770e59ada053e1656081a324debb64b96afa942a86e18f28a"
    sha256 cellar: :any, sierra:        "beba76f7c3b6c54228c8972cfa01d1cb06d309d870f23ce6aad457c23e11742f"
    sha256 cellar: :any, el_capitan:    "a0e373df44eee915d0f9259fb8627df92bfe3db8547bf66a9918f5c398342709"
    sha256 cellar: :any, yosemite:      "99e8bdd47cde67290e0854c8854c0eef32a995ff10cbf1f991ca37834d60e0a4"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end
end
