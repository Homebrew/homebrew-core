class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.23.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.23.orig.tar.xz"
  sha256 "5efc53efaef151301f4e7dde3856b66812d8153dede24fab17673f801c8698f2"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "77907a43a415210de713d9e82588b452e5546a31b42194c7c75e07486d319a51" => :big_sur
    sha256 "5b066bc471862c8d166082f0d1bf6b132aac0117f67e19bba139dfe907eb2614" => :arm64_big_sur
    sha256 "bb4c986e9f49c7eea6349a536889e6223549885c0aab3d7692542cd48bc06481" => :catalina
    sha256 "066330367dcc69e8d200a1d26a7f6ca580ecc3c397a686fa3b2fbd36d5d88ada" => :mojave
  end

  head do
    url "https://repo.or.cz/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
