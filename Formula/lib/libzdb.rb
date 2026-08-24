class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.6.0.tar.gz"
  sha256 "c29712aba58ce3c428e6fcf4c96f86c853dde5449da9adfaedbe69e6116e2e17"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36f4d61a052239e79be5c8cd4fe47260f53ed4af341005a688bfccdc410d2bab"
    sha256 cellar: :any, arm64_sequoia: "ea1724d1e20b27aed580f4c7fd0c915163c304784eab095757d42216f3445ca4"
    sha256 cellar: :any, arm64_sonoma:  "a588127bd71efb9acb8a2b232da1c13d73c2a35b9c281fc6a366c69596246145"
    sha256 cellar: :any, sonoma:        "c113099f7a0a87e6446879d6661996b863ffe1ab12714e8c762b64795259f123"
    sha256 cellar: :any, arm64_linux:   "9cbc806998c7e91ec7faa3178fd9340a947fdcc9ddf7c1cb6adacc6faa70fdb0"
    sha256 cellar: :any, x86_64_linux:  "79110486938ecc49c0854443fc4497e0a666101f613ddc5acecae8b0ba55e0f6"
  end

  depends_on "libpq"
  depends_on "mariadb-connector-c"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-silent-rules", "--enable-protected", "--enable-sqliteunlock", *std_configure_args
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
