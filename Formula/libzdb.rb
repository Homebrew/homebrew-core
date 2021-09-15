class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.2.tar.gz"
  sha256 "d51e4e21ee1ee84ac8763de91bf485360cd76860b951ca998e891824c4f195ae"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "db54eac2ef107864c43f2888628a30ed7af5d3eae6f892b491ea7f2fe542a35b"
    sha256 cellar: :any,                 big_sur:       "ae4c8d97236e248f1fa8fe189a4f7c049009335bc8038f541c8faf6c47c3d0e4"
    sha256 cellar: :any,                 catalina:      "846888a4d5e47cccac9d41c95223974b16724b681c57e12e616a503409507014"
    sha256 cellar: :any,                 mojave:        "7040dee7ee6eeb60e81aeacf6cc33f2e6e1ea5895c9a53e4a2b94ca509852974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f196f9126a86ccd959083301741b9d68e0e49352cb51b83cf3d82c52a0669be"
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

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
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
