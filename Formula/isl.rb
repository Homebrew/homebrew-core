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
    sha256 "15376fb7aff7adec3786e6a31ec9b5cad585fd01ecbd5c4744ef9461b10965ff" => :big_sur
    sha256 "ab5b1ccbb471b04c3e4c33608857057188f96d95f18575838f526860d8ac4f44" => :arm64_big_sur
    sha256 "b5319e3bbbb36ef3536d841999b7497b3dce4bf9e07fb04f6b0db716e087896d" => :catalina
    sha256 "29213891860c971e084d1e2a3d1ad00c92371140dea599aae2894e26ec0d6874" => :mojave
    sha256 "a1193c8b06c31abc4bf9c1ef9bb93c4879ff5ba4050b4a06c22c2a0048d3c87f" => :high_sierra
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
