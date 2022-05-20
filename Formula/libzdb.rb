class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.2.tar.gz"
  sha256 "d51e4e21ee1ee84ac8763de91bf485360cd76860b951ca998e891824c4f195ae"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a984ed34d47824121c308a122c397e06429fa80db31c5511de5dbd38a5a12ed7"
    sha256 cellar: :any,                 arm64_big_sur:  "82e9b70755a848d0d9386c42ff2e771a2acdad6d2497251d6dd9d0b96a26edf9"
    sha256 cellar: :any,                 monterey:       "406b423b65940127d9d6ba6c7d20c5926be12a1445539e40e376e746e19323e5"
    sha256 cellar: :any,                 big_sur:        "75c8ff67e93358dc8733bc0505b7a2a7f18be1da23bdbf1c19e97de60c03cf08"
    sha256 cellar: :any,                 catalina:       "4ae11691a08964b1c88aaded3dc7d9c7b5ac47cf2389fa790e76aa48c874497e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb34c1e09a5fbac337d3eaa3b722bf51824ae2a811712e29b2f2dfc01444f52"
  end

  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
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
