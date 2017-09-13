class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-1.7.1.tar.gz"
  sha256 "961296ed000d4fdb4ae8690613bba2af2e4d634c044f947795abc24e9caf644a"

  bottle do
    cellar :any
    sha256 "3d6014e37bac0a264e32a8210decbe6dcfa8e8c8512591d401b041e6483833c6" => :sierra
    sha256 "25f95e58cbb615835cf32e623319a1d6688f64af9547520f76008eb13f500a71" => :el_capitan
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
