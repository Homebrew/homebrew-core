class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  license "MIT"

  stable do
    # NOTE: Always use tarball instead of git tag for stable version.
    #
    # Currently isl detects its version using source code directory name
    # and update isl_version() function accordingly.  All other names will
    # result in isl_version() function returning "UNKNOWN" and hence break
    # package detection.
    url "https://libisl.sourceforge.io/isl-0.25.tar.xz"
    sha256 "be7b210647ccadf90a2f0b000fca11a4d40546374a850db67adb32fad4b230d9"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93e737d38d526bb8e78379124c237b3a532c2c8a77562dcf178baa955b193a97"
    sha256 cellar: :any,                 arm64_monterey: "764bde8aa0d015c13cbf53891489f3ef56a5951f617ad9906aea34382dc1f4d1"
    sha256 cellar: :any,                 arm64_big_sur:  "24f86a50eea8a2d4dbc24ecb5f8b8ded61f6f7cd7054886b5dafcb82854b28ed"
    sha256 cellar: :any,                 ventura:        "0c2e7a06a69bdd03db2e32aa437cb83b6152b7cd00893b2d4b737abb75d8f67b"
    sha256 cellar: :any,                 monterey:       "568dd08209728ad3a036cf45287ff8384b9ed821460a216a9a79fa80fdcfbf52"
    sha256 cellar: :any,                 big_sur:        "be6456799bb670c16115d89feacf72cee9b444fe87aca6b1bd350bfb89ff6247"
    sha256 cellar: :any,                 catalina:       "c2ccd96c92ab0bbfdb775ccd7c8f20c2057cbe976769cf078e728b6f5f5938bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0244c95ed9cc89b826868de83bec3150fcc120add1265017176770150757083"
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
