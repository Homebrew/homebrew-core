class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.5.tar.gz"
  sha256 "27ada2dd86fe4c9487fda52e5e1cffab74e2d1478b952a1054184614102dbbc3"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "5e1ed5a8c6b4fd0ba5216bcae308778b64cdb2e36c8456b4ccbc16987ac9f4ea" => :catalina
    sha256 "66075d2897bb6690ba17ac0d833060fbecebdbf3855429d8c1182feb5df72197" => :mojave
    sha256 "b03c35ce73313a6e0e675e15575363d0665c5a44e7314d7b2bdc90b18a3ecb1a" => :high_sierra
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
