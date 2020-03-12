class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.1.tar.gz"
  sha256 "b9a7b59a0a9f53dc87ce1b5a919f21b8cd6448c04a9157bccef1e3c1dffd3ff1"

  bottle do
    cellar :any
    sha256 "1d523ee67b9eb18d8e4311f722b24d60c3ca35994de9e2cb945f20766e922630" => :catalina
    sha256 "e33de57009c4bee656f08539b7eb1e982db84e6b2692f8446d1364d1ff5f147b" => :mojave
    sha256 "ef5be4752f5a6f663841299ee699e9c3e361d9dfa70022d82c4269bcb3707d38" => :high_sierra
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
