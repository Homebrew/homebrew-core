class Isl < Formula
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  url "https://libisl.sourceforge.io/isl-0.27.tar.xz"
  sha256 "6d8babb59e7b672e8cb7870e874f3f7b813b6e00e6af3f8b04f7579965643d5c"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8177901745f0a718e0047b78cead08a40308055e648790272b9fe2b8aefca259"
    sha256 cellar: :any,                 arm64_sequoia:  "de143fddb0e20b6b73016ead1e625ebd429db53918200d093e4da98f1e758889"
    sha256 cellar: :any,                 arm64_sonoma:   "8f1af90ff2967e80c1a757e8e6aae61c9f6876a8ad98c1613e252f7daaa8a483"
    sha256 cellar: :any,                 arm64_ventura:  "7d74b1abc36c01f14202d8d4f3105826cca0a1ac5db3fd831c8fd3673097e2d6"
    sha256 cellar: :any,                 arm64_monterey: "f09ed357251a8f1771f93c22b5c18441299cf4ecbabf4f83a63b71abba565904"
    sha256 cellar: :any,                 tahoe:          "1e1c718563e9292e45f35d4dce44eb46a0c47f236a789e5e8ad1c278fe74c1e5"
    sha256 cellar: :any,                 sequoia:        "edae3d6050998a8b6c40d79244d1c73231537371e7a36a3a72f756ed965088be"
    sha256 cellar: :any,                 sonoma:         "23be453b3fbe9ab4a1baeb8a99eea31a6362825f03f74a1c7015bb0bda9ad4d8"
    sha256 cellar: :any,                 ventura:        "df3c2c3161184a8cea83dfda47bbf31f81e3527951c2dc72bdeb2ac1638e2709"
    sha256 cellar: :any,                 monterey:       "fea18e3734c269de46cb70dc7a263e5784e0e67d16e59598aaea22618c6a4650"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "58237313da104ff5b3f16289cea5fccd51465e4ef88f977ea7f91a2a578be1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c8bf618d4e3c68c27eed634bd7695104ff5daa37246253aabce80d7c1ac7f5"
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
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
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
