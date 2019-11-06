class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.17.tar.gz"
  sha256 "e8c15cfeaa932e0ae9527584a3091e186eaed138648747b7f5ab0853ca0c40b6"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "1040b1e30475c6f9d4d256c06a694c3919a26d16e911cfee688f6941833a070a" => :catalina
    sha256 "1fbeec29bf84647ad9fe84bb7d076d9c431305693b1bdb7812fb0aa172108b30" => :mojave
    sha256 "a46b98302d26ec6351d46a091b3b6eea489172f0ad2d27855a442aa94a5c9ce6" => :high_sierra
    sha256 "ec7db6c3b9db72e581b37e6bf44130a201e0f608fbc4f1cf6c64443fa05a34cc" => :sierra
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
