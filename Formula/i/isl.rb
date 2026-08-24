class Isl < Formula
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  url "https://libisl.sourceforge.io/isl-0.28.tar.xz"
  sha256 "3dc31b8e1b18329e42d5dfbf84dd55e15c59b61569a2ab246f61497d9592f727"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9adc3d36bfaa7652e75d63fa7a61942ef9a9d1c5e857e8e38a578a78636bf4c2"
    sha256 cellar: :any, arm64_sequoia: "a0b9da629db115bc15e5762887c455fdb13ac0a8028f20ee2639eae1f578c762"
    sha256 cellar: :any, arm64_sonoma:  "56df07c199b66181731ee140c66d2cf368bbd4a2dc365bd0518782cea7a4494e"
    sha256 cellar: :any, tahoe:         "2d537de6aaeab09fb237856bba6dec9cb5c24c3cac172ea322eb12a4980ef92d"
    sha256 cellar: :any, sequoia:       "dca49213f0e9bccffe590c7477de4455a0dfbb65ab542854b1c1f52abfa10213"
    sha256 cellar: :any, sonoma:        "c1e478f3a363ca5ea1ac4520db7c6c4083139dc77fe58d6d30609795d2c0909d"
    sha256 cellar: :any, arm64_linux:   "9bb3cf80a3389d78be3ddeb7b6dfddf38ae5e7f036dcb532d53e36bc79bdef18"
    sha256 cellar: :any, x86_64_linux:  "71ff58966339279d9a1012079f817a53d38f269fd6e4c86bc2ea17534a73c86e"
  end

  head do
    url "https://repo.or.cz/isl.git", branch: "master"

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
                          "--with-gmp-prefix=#{formula_opt_prefix("gmp")}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
