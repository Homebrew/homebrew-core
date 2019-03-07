class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.12.tar.gz"
  sha256 "9097ba1677d183ce8593a835f367950ff39fc99d2aa018d1cf90d0a21fa7fa6a"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "3ef1b3dd5b710064d5437590b40ac1b78ac2a4c453ccc7c829d803167b13b1e9" => :mojave
    sha256 "121d8ea31612d0646fd8f350eeccd322bf6d15d54291ded41b87d632f7c588fe" => :high_sierra
    sha256 "a7a9840ca58f8d96a3c2b082335f3ad394cd904fe64c174abf6df186e31c0218" => :sierra
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
