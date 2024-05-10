class Isl < Formula
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  url "https://libisl.sourceforge.io/isl-0.26.tar.xz"
  sha256 "a0b5cb06d24f9fa9e77b55fabbe9a3c94a336190345c2555f9915bb38e976504"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00b4bed8680e65a16f0594b92e6413237fef625b79320ccdb3f6bb3f085e44c6"
    sha256 cellar: :any,                 arm64_ventura:  "1814fe867c61b34cd5c763cf2ebda99d7883db78348c8b663f98cc95a1348d16"
    sha256 cellar: :any,                 arm64_monterey: "0a3e83c458420e4b469ad7464d16d6c9cd26a888059358eb5f1f9d3cff54bbd7"
    sha256 cellar: :any,                 arm64_big_sur:  "a68a647249ad644cd8d1e1057bac65e5b4e1e08f9adaf15a07121853b0ed40cc"
    sha256 cellar: :any,                 sonoma:         "879bd3d644e9a8a8b43b771de24d56999faf6ab47d961a316cc469de10a6fb7b"
    sha256 cellar: :any,                 ventura:        "0301489db7b26967657be0f6c89f11ea7e1e5fb50631686f86c597b01c00dc85"
    sha256 cellar: :any,                 monterey:       "0dcc555fd2517c6c93bca8999c741029bbdd821bfeb397505ec1f98deb79c551"
    sha256 cellar: :any,                 big_sur:        "91965ce2f54c7d1b16747ed05de989a3a122f5dbee67546bbf9bf065873b13c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db14ba1e4ea23ab41e06930dcf25ae9023c5e395c88602da2a9b6a98d54c92d3"
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
    system "make"
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
