class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.11.tar.gz"
  sha256 "8755c79d18054ae842b8744575fdfb55b76a8667cea8186fa22cb68bd5fa60ba"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "df684d4f93303e9e558a0e76e183cf3d2f023dcc72ea89636187da767043f167"
    sha256 cellar: :any,                 big_sur:       "2b6b8db77a59ac10cb719ddabc427941c78d43612fd945145c96f054bb5654a7"
    sha256 cellar: :any,                 catalina:      "03ebfd56228b524fad48bad6017146a213fb9f2bff088ad1b78a50d8a6d40855"
    sha256 cellar: :any,                 mojave:        "8dadd7bb9c24df3191f3c8e512be6e34ededaf7d062a57662b45ae9a1934c394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01395024d805dad47330df8af7f78616b322ecc900ca88053c09236e33e354d1"
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
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end
