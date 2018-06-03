class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.23/pkcs11-helper-1.23.tar.bz2"
  sha256 "12f962f8abd27ce96a85602e246ed36f7ac763e296bc0ab750412bd5cce4fd42"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "a04c69089ae814e9bb645e6364ea02e6cc7ec259bed5aec64851e20dee099531" => :high_sierra
    sha256 "594d75ffeb2d7a7b8c32a0374f07af5719f4fbdfffdaafc6f083eb193a0a6aac" => :sierra
    sha256 "626bff1e4f4ac45cdeae728e95ad82459a31afa9a4c80abf16b20daa6e161663" => :el_capitan
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
