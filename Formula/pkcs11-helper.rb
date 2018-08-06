class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.25/pkcs11-helper-1.25.tar.bz2"
  sha256 "01591ff73a21a79935fb03ba511f439d603b3048759702a09207536b30a1fe0e"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "18cad8635476125066de372023febcbb59a2575815800f0bee279217afabba02" => :high_sierra
    sha256 "eec02c88749edb32c9d1162b26b00dc19e0fdae36e107209e2117eb43d3ea47c" => :sierra
    sha256 "15bfcd1e28e83f164940341dd472c1dbc69dbc4340e418bf335594f88b0a4abf" => :el_capitan
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
