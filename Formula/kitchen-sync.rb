class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.7.tar.gz"
  sha256 "65489d348620dec6369a9c58b36220d8984b8cccb5443fc259d13e484e7f96ab"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "c9463980317bad8580b58ae39af0883b4eac9d8f8ddbd8d9f39afc213e5fe1fc" => :catalina
    sha256 "a3c6500fadf51bcc6102b514e57dfb39625a5c7d19d26d2477acf49f807bf3f9" => :mojave
    sha256 "31eab5d183eee6f0ab99ce9d6feb7ff7f4d16e7f96e7939309897d03a148d320" => :high_sierra
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
