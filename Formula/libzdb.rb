class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.2.tar.gz"
  sha256 "d51e4e21ee1ee84ac8763de91bf485360cd76860b951ca998e891824c4f195ae"
  license "GPL-3.0-only"
  revision 3

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "97863718c9449c76cc6c4110b0baf593e9bcdc4f32441e6606909db0f41d53d3"
    sha256 cellar: :any,                 arm64_big_sur:  "13ff97adeda3312fa93df1307decf063970c15a422bab11b02e70f05e8fe4433"
    sha256 cellar: :any,                 monterey:       "bd150bbf161106ac91a6f262f4ebb729633dbea3bac7443c67547b8f0580704d"
    sha256 cellar: :any,                 big_sur:        "c7469d284a6de923bef437b86d8b0d522d99e3ac469c9c8c2e7bf922a4bc8ec4"
    sha256 cellar: :any,                 catalina:       "64f6efd25b5b52c3622f6e1a51dd4d34b5cedecbceabac42c0b88f58225955fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b0d8787ff8b85ba13e823d77020504d3e6259db146b12892e2316e2b5c61b0"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  fails_with gcc: "5" # C++ 17 is required

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install Dir["test/*.{c,cpp}"]
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lpthread", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end
