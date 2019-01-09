class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.10.tar.gz"
  sha256 "9382642c3f120acd53c8b76c9fc91d1dfc3f4820ee77b1180f27f7d5111f152a"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "14d647e7686a1f99e60af426e6b4a94418d5dbae27e2cad2c1cd44381dc1b5ad" => :mojave
    sha256 "d5ea7d77da94e04b08c42db905b737bd50f845576200f82166d2ad3d6eb5be24" => :high_sierra
    sha256 "5e9eabbb0cf4d5ca14923eaaed0d7dd0280a43041e676ea04872efe48f4b683f" => :sierra
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
