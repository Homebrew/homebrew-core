class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d9a1e85054f21d735dc85853908b1685df18539775bcc7be208ed089b68e7715"
    sha256 cellar: :any,                 arm64_monterey: "e8e69ee7caa822faeefbbd3beb5e42d60796daae8e9865d351b35a09d30eab23"
    sha256 cellar: :any,                 arm64_big_sur:  "bd1c26eb89919f26a72458310340981f2360444facb8a06007f831cdde8969c3"
    sha256 cellar: :any,                 ventura:        "4f337503e65d099fee98d7cccf111ab51d45bbaf9ea8ad4bd7ee8f39adf59a2b"
    sha256 cellar: :any,                 monterey:       "fb27c254646707f49b4c220493a904d52c166b8432e29ac89df1c2c0bdb1842a"
    sha256 cellar: :any,                 big_sur:        "503b5ac11a438ee0ce95b4a905575061f6710948e1fbb0d25e8c1a2b555d1bb8"
    sha256 cellar: :any,                 catalina:       "9de6c1b21c609053ff01c54f5595dcc7185d9b7a6b6ecf8d65076ef7c9f93d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcf7be43843a73041a75abfbb79fa2cdb72a82d3356e7413fd9b12ab40ac3ea"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
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
