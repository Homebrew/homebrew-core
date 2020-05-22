class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.3.tar.gz"
  sha256 "6fc6adcd7882f76f295ab9e62f83f0e2b9aa58da4364233505c76b277e4b6c22"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "cf2c8c6579f4ae024e7a4bbec7573d23306253c2e9dd440851889359a4c3a9c9" => :catalina
    sha256 "2bf2fa25dbf85214cb4403d57874f5124703a018380d01431e5e8fee6688a589" => :mojave
    sha256 "29af1ed63dcc3dbb653c6a676e8bac5f6fcebe9e6e1f6b769be246b2b60bad40" => :high_sierra
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
