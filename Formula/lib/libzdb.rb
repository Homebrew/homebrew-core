class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12fe0b3df09370d167061c89cb3f15ea961cb737a1c6b74c2e7c98e1a90acf82"
    sha256 cellar: :any,                 arm64_monterey: "fd60240b639004dbf24257d3f37f970195b4951bc21d8bba638842e6b76904d6"
    sha256 cellar: :any,                 arm64_big_sur:  "23fbc9b3adfc813e6a81dfce88c87447a40c379a9a49a6121a81900a9771e393"
    sha256 cellar: :any,                 ventura:        "f9ad30dc720c4a4566b1635b02801010ff87c32733e5caf3ca05f778fbcaca50"
    sha256 cellar: :any,                 monterey:       "b391e61607acc179a3b3fc3614723a50431926ac6734106ed2fcd4493bd0e7f8"
    sha256 cellar: :any,                 big_sur:        "bad55246807663ca1a3597184b74a98a7cbdeab7975792b7160f2ea96e76ebc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd0f4bf52d4605117e51f27fa1ecdedcbbcd23c85a446ebec54f282dad8fc137"
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
