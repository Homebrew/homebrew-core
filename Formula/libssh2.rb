class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.8.0.tar.gz"
  sha256 "39f34e2f6835f4b992cafe8625073a88e5a28ba78f83e8099610a7b3af4676d4"

  bottle do
    cellar :any
    sha256 "5e365633b3961b88ad27f40e4e892929c848a7bd1d77259a0e5eab6bb51e0490" => :sierra
    sha256 "3b9cef10df7eb69305daaf5a2f3bc13bd16b42e318f742de31541592a3da1f36" => :el_capitan
    sha256 "5bcdd6ec9369bebadeef640262e7034a92024b353122ab40a1a26d1d5dcc7761" => :yosemite
    sha256 "75a02f552af40d6ed0802a610daf4b86f14dec925b671fe86deb24c8eaacfb22" => :mavericks
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
