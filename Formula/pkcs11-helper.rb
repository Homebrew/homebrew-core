class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.25/pkcs11-helper-1.25.tar.bz2"
  sha256 "01591ff73a21a79935fb03ba511f439d603b3048759702a09207536b30a1fe0e"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "36422ef6734e3c0eece0725d94436b9a60bea3cfc075010c5b97c383af9774aa" => :high_sierra
    sha256 "095e40df3c56f2a92857a430afb698752b55a58c8dc86e8f003bf8e555d2faec" => :sierra
    sha256 "14e7b1cb73d65cb3b99cf8159caa52b3b6c4d926e1990810c1ed5964fe5a1bd1" => :el_capitan
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
