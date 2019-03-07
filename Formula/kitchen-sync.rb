class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.12.tar.gz"
  sha256 "9097ba1677d183ce8593a835f367950ff39fc99d2aa018d1cf90d0a21fa7fa6a"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "e97491934f99247413b0a957948f3c3e77734b50010b5489c6af12bf235c607a" => :mojave
    sha256 "4edb8b6931ed566b08485ae39107e1eaf987070b6a56e5e2b694d3b5930b1a92" => :high_sierra
    sha256 "d4fb277426fe46dd4bfb2aaac1ccc61158ced672be060d19630cb6e7eea92cbc" => :sierra
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
