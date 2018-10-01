class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr/"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.20.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/isl/isl_0.20.orig.tar.xz"
  sha256 "a5596a9fb8a5b365cb612e4b9628735d6e67e9178fae134a816ae195017e77aa"

  bottle do
    cellar :any
    sha256 "255c72632a88dd8a8039e0cbe2727ee0fde649fc15076cf0315b8e1e25b99917" => :mojave
    sha256 "d51677cd4b4b714c2b0835e8fc6e5949748ca159102b6c53f1159b596135da70" => :high_sierra
    sha256 "bf926bb68fd2451eec691813a3123fc2cfdc4d988df10f64e073bef9cd264995" => :sierra
    sha256 "832bf16a2a71946d9c6ba2fe1b99b2e1334fe4ac8d30fe232690bd4931a3598f" => :el_capitan
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
    system "make", "check"
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
