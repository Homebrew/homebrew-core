class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.8.0.tar.gz"
  sha256 "39f34e2f6835f4b992cafe8625073a88e5a28ba78f83e8099610a7b3af4676d4"

  bottle do
    cellar :any
    sha256 "74a0fd6f2fdc35ba837f637acaaa593c09d285e4eca0d143d9cd3f7f9b69cf21" => :sierra
    sha256 "0cb444543e7d56aa72ada9b929bee4b263a3f4780ebc00b7dd12b159db7bb8da" => :el_capitan
    sha256 "d4572b94cd88cca756d8a852445e39868e6fee015c6463a8973c79136abc8aed" => :yosemite
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-libressl", "build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}"
    end

    system "./buildconf" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
