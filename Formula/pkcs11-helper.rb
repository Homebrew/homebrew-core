class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.22/pkcs11-helper-1.22.tar.bz2"
  sha256 "fbc15f5ffd5af0200ff2f756cb4388494e0fb00b4f2b186712dce6c48484a942"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "b752623b5d3572650decfa02539c0fe2af9bbcc16fa9b1bceae133f931471fa2" => :sierra
    sha256 "99dc05bbb35ecf1dd3ce0454b798b3e08eb1434e0bb98eea0bd1d049d844019c" => :el_capitan
    sha256 "60b254cdd776669ece91e3651d4269272ab5bd358c9fcf1e076bcc12b99eb515" => :yosemite
  end

  option "without-threading", "Build without threading support"
  option "without-slotevent", "Build without slotevent support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-threading" if build.without? "threading"
    args << "--disable-slotevent" if build.without? "slotevent"

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *args
    system "make", "install"
  end
end
