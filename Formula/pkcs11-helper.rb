class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.25.1/pkcs11-helper-1.25.1.tar.bz2"
  sha256 "10dd8a1dbcf41ece051fdc3e9642b8c8111fe2c524cb966c0870ef3413c75a77"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4bf7e16dffead843a4158c7d5d17faaa2e4bcc1c7cde292e8faffff4cec8de47" => :mojave
    sha256 "321866c8bf6dc4ba2cd670971e71b87e49b6c6f5d039b3c765b1af3cf1b4926c" => :high_sierra
    sha256 "87e74dd0bff5614912c69b8c071096b804ebe82003dcc9e92c15cc73bdce86cb" => :sierra
  end

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
