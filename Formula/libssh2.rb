class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.9.0.tar.gz"
  sha256 "d5fb8bd563305fd1074dda90bd053fb2d29fc4bce048d182f96eaa466dfadafd"
  revision 1

  bottle do
    cellar :any
    sha256 "2c4dcf8149663f9a133deac5bc42ce308d1ced90227cac391ca30b0ab2d381f9" => :catalina
    sha256 "327c56ad6a54894e5ef9aa3019d2444d32f1d0fba80925940100e517dd3109c9" => :mojave
    sha256 "ee29f44ef6fb59242fc7ee1747f02df2287722af4a45319289c9ee224367ba06" => :high_sierra
    sha256 "769fbbdc4e67b8de15c269f66a6efe86c5b0195df56e7e46b44377a572800efa" => :sierra
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
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
