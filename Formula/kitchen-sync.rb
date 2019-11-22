class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.17.tar.gz"
  sha256 "e8c15cfeaa932e0ae9527584a3091e186eaed138648747b7f5ab0853ca0c40b6"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "6f5d6aedbfd703b89518a24e0017fc9600dbf93ef03222f61d6fb137e6c66e9f" => :catalina
    sha256 "db5d563bd89d7cb4885213f8934171f059279b1f674dfcce6f14b36b66e2f5df" => :mojave
    sha256 "11ba563b62bd1aeb3adb5e01c7633bb293843f44c730342d52973cdb2dd91da8" => :high_sierra
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
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
