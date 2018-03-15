class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-1.8.0.tar.gz"
  sha256 "c0a3b4f99916c7124b1964b273fc3a1969e34228633f68a1a9615f2b420236ce"

  bottle do
    cellar :any
    sha256 "3362c36ab1a1d373a576ced24ece03b0a957f50aec7ba32d772d11e610b77835" => :high_sierra
    sha256 "ee245e1d7f3f82d2d84041b701b456bb10839dd82df214f1dfc5c76ddc9867f4" => :sierra
    sha256 "bae025cc2353fdc08b2ad56651e5e44e41701ee22c03ed8265e6ffcf84ea2847" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
