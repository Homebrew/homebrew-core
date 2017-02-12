class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.22/pkcs11-helper-1.22.tar.bz2"
  sha256 "fbc15f5ffd5af0200ff2f756cb4388494e0fb00b4f2b186712dce6c48484a942"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "5b23024c360d1bb3bd84887d4983354d1b335fc84d693f7505e5633ee23b2411" => :sierra
    sha256 "20249bea63ab70e0daafd8d398b26638cc2941caab4773360828bf775506c0f6" => :el_capitan
    sha256 "e37790f0d0ca3f4fe29b0ecb88fe8c2e6711a5e020c96c2ffbd73a2aae3eec31" => :yosemite
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
