class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.9.tar.gz"
  sha256 "9e2dd1200a8bc0711bb69b9f0aa1e4aa6a3c0f7661f418f2b0db02fee0ec1059"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "8d9899bdc33c72aa5a75b5c1be48dcdaa19bddf5676f8861e032d4f94fe1740b" => :mojave
    sha256 "0a08dfdc51586d7b36ce4ae0f9e9856bf4b52ac35689444096f0d41a211a8d37" => :high_sierra
    sha256 "14640cda3cad294f6ca88c623dd77ff2d950a0f92a63bb87ede33140de60d30b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  needs :cxx14

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
