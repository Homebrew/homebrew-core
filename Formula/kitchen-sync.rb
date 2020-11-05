class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.10.tar.gz"
  sha256 "98d2024df192571b7a5b4c21f0522d7d7187ac2a1411051e4594f3a66ebfa1af"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "4f67d2971d1458018c776f4a48c868abab5efcf3e911a1113dc1412000eca992" => :catalina
    sha256 "6aba34fa6c8e2b5eb0ed4aef9d3f3ed6ab884550a6076c761e89ead18878661b" => :mojave
    sha256 "c75a5139ee4fa77c60d30fc5e4c8157b6aa27de4129960aa0cadd80a6a6aa553" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end
