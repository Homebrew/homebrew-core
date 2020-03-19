class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.1.tar.gz"
  sha256 "b9a7b59a0a9f53dc87ce1b5a919f21b8cd6448c04a9157bccef1e3c1dffd3ff1"

  bottle do
    cellar :any
    sha256 "ed837893c1752ce339e88ef35f857de8d0557387b45a8efba005cb81d06f731d" => :catalina
    sha256 "2dd6bb652a33079c537f4401dce17ee531adbde821199bed803c3b0dc96cb7f4" => :mojave
    sha256 "f84fbc774c4269e5db5ea6336986a10afe235bef48d6ab7ef2b6dc406447431b" => :high_sierra
  end

  depends_on :macos => :high_sierra # C++ 17 is required
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
