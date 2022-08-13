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
    sha256 cellar: :any,                 arm64_monterey: "fd195f268e04cb92867eb892ce7f6c4d745d2a332d7e556ba15446c0c913df4c"
    sha256 cellar: :any,                 arm64_big_sur:  "add84b2009e944ba199b3cebd460b8fddb31e15b594d89b5e092d7cfc433d7eb"
    sha256 cellar: :any,                 monterey:       "c032c8f4adde4a7d1ad48276bed4a9fd1dc8d532b5abbf1d558e94382c298f17"
    sha256 cellar: :any,                 big_sur:        "738890ada6a9d80e2e32fc4b0deee492c4932fadcc51926d7d147d9888d82065"
    sha256 cellar: :any,                 catalina:       "949c8e505af733fab357fc76fc6f8aef95b1e6693321d2e1e8e9a8cb4c6dc62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0290aa392b46bab411f016ec05594625507d61e7737721673fed5778b2b89c52"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc" # C++ 17 is required
  end

  fails_with gcc: "5"

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
