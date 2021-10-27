class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.11.tar.gz"
  sha256 "8755c79d18054ae842b8744575fdfb55b76a8667cea8186fa22cb68bd5fa60ba"
  license "MIT"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7cb0c51fd57fa314a05bbd4ea90690ddbc9c9c550898a97d7ab5915a495b1634"
    sha256 cellar: :any,                 big_sur:       "fadb1e90edb4391bbf7514c5f2cc6f6d4373b10962b4806f991879fddad8ac69"
    sha256 cellar: :any,                 catalina:      "5e929e6f0cfb76aa6bd98a160c649136f7770090085253add3c8105013ac8000"
    sha256 cellar: :any,                 mojave:        "deb520f2995563451f9695efc970af7b8b8eafad7ca1c55efb0b75320b057876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d26fd4ba6991e01a5a5178228e936e1e89868d2d1a70ab9bb5bed7e16c2b6da"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
