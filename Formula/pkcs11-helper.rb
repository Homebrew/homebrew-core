class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.21/pkcs11-helper-1.21.tar.bz2"
  sha256 "7bc455915590fec1a85593171f08a73ef343b1e7a73e60378d8744d54523e17c"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "93b56ec6a9bcf9810ac4069356d3aee202c41f3f6b764ca2daee16734a85cc0e" => :sierra
    sha256 "e46f8af45fe8af173ed539a1a8222ee0ed8b2bfcee76c69bd3c059545cedd3be" => :el_capitan
    sha256 "843a514fd6e940365b74ac61488e972e934a39ca022cc1a2363acc2e04c4c572" => :yosemite
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
