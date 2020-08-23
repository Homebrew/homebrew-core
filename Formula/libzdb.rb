class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.2.tar.gz"
  sha256 "d51e4e21ee1ee84ac8763de91bf485360cd76860b951ca998e891824c4f195ae"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "114982357474fdd8af3df7d11a3575e81686ff55d6c2018b5385c7f5acfee7ed" => :catalina
    sha256 "bc52a04fe2ae5500200c1521f4e32497c9eee2d2c4087e60c9ed11a09b2cac67" => :mojave
    sha256 "123039235efee305797c3252e0e4b07c93989785165c044eefa9f86eae73f9b0" => :high_sierra
  end

  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end
