class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.14.tar.gz"
  sha256 "21c8311243166fa4d3510a291a437002163768cb2f6a704adf27bdb86e87c679"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "a4ea9ce12bc2a038caa11b26b8107851585111f8cbb56c1b76a2650e1167ee2c" => :mojave
    sha256 "bf05a2103c305de462f560e2b4d162cb5f486db3d8e565322d6e6be1a831472e" => :high_sierra
    sha256 "d258cc6e09bdaa0c2eff78e0702d234268712110f0ccce1d25daa44fcf2cacb2" => :sierra
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
