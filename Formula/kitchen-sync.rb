class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.3.tar.gz"
  sha256 "6fc6adcd7882f76f295ab9e62f83f0e2b9aa58da4364233505c76b277e4b6c22"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "411cbab9d9f94257bd552b69455659a6028df775120c7bfa6180f6c65961519c" => :catalina
    sha256 "039fbb6b0167a6927b98fd130760b03e9c2c89f376c21ad49f934e7e115c9c79" => :mojave
    sha256 "855004adc2a2661e800bc1a998cdc595c2d9ffb7464bdc3559a16ac1dc6278ae" => :high_sierra
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
