class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69ee497f93eeec69092089d3491992dbfef8eb9191b91ff41856132a799b5e2c"
    sha256 cellar: :any,                 arm64_monterey: "9c941469057d1e6bc266f717253b4d273f79a206cbb88c1222b9438ffc45405b"
    sha256 cellar: :any,                 arm64_big_sur:  "7a63987fcff8e633e748b00623b2c4f8459eeffc58c14c415b523bab8a51b04d"
    sha256 cellar: :any,                 ventura:        "695bee5cdf964b73531e8d0ac5668f4f4787958765da4dccec56466bb1e8dd02"
    sha256 cellar: :any,                 monterey:       "fb11437e4090f3a53cbdf84556234375cdaea1b0a8e0d30819ffd064ad6844a2"
    sha256 cellar: :any,                 big_sur:        "928efd66e2f2f6032982635fa2b6b36a2f55ff9e05c44554dddc5600dea1de65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2decd203e733b4c7c930d14cced666603bf77ab673068e4d66fa0fb7499c1b96"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "sqlite"

  fails_with gcc: "5" # C++ 17 is required

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
