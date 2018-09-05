class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.25.1/pkcs11-helper-1.25.1.tar.bz2"
  sha256 "10dd8a1dbcf41ece051fdc3e9642b8c8111fe2c524cb966c0870ef3413c75a77"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "f3691f198461a3454a23d28ad1654300fab2a06f0f552bb40120f30ace2a310c" => :mojave
    sha256 "8ef9dab823d0d222506ad95b9501797230e8ff6a79ac1bc45137de708f0862e8" => :high_sierra
    sha256 "98e6529b783c275380faa8282d2d0bd17be5c3d65d41db184d652ea85978ed98" => :sierra
    sha256 "2cf6979b8f750c8e58005c4150171a547b6b4a06bdd758fcf77bc52a05d48ac2" => :el_capitan
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

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <pkcs11-helper-1.0/pkcs11h-core.h>

      int main() {
        printf("Version: %08x", pkcs11h_getVersion ());
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}",
                   "-lpkcs11-helper", "-o", "test"
    system "./test"
  end
end
