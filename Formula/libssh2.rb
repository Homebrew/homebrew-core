class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.8.2.tar.gz"
  sha256 "088307d9f6b6c4b8c13f34602e8ff65d21c2dc4d55284dfe15d502c4ee190d67"

  bottle do
    cellar :any
    sha256 "f927577d783406a3b0fa010b39acbfc39c29d262dd7a1fa38c4abe69e58139a9" => :mojave
    sha256 "98f643593c20a04b588b0c96332f83a9106ccffbfee2d8b45aa033ce741c0903" => :high_sierra
    sha256 "57327cbb9408518a9ee7b578bd30192730c730bdb0508f53e14671dea5965a92" => :sierra
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
