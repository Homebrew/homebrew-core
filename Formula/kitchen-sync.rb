class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.0.tar.gz"
  sha256 "2079fdcbc9f465aebc9fbe1aa55a0f4d01bd14ffb242eb8aff99bf1edf571b08"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "6676b783d9f06d0283d5fd0ade5e34fced18f25009c78aab4d6482978658ff78" => :catalina
    sha256 "f9ef3897384ba8cca73a74b39718035568599ebe63b094352b3c927eb06cd6c8" => :mojave
    sha256 "21f25b77bdb986066ecb4f8d6bbf0f487c1252e7697a56dd25557089c4385aa8" => :high_sierra
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
