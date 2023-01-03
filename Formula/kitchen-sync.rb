class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.16.tar.gz"
  sha256 "8bd1da4951dc624b0351677d296e226b3c7ec97670e7b79b4978e082bb4155ed"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d5834d3d6ff1d32e97e858726bcab2a5cf1b7d2ad3e0517e041ebf0ef0eefe5"
    sha256 cellar: :any,                 arm64_monterey: "b8668dd02b0579352bf5eb255a8ced3c343426f5aa1f977360abe243e7d304e6"
    sha256 cellar: :any,                 arm64_big_sur:  "ba141afe739a227cade93e748dfb3aa452c816051722324a527b572f8ac8bc5c"
    sha256 cellar: :any,                 ventura:        "696c4c4feca61d55bce859ce814064f56247068d9ffe30226c67c0dea54ba820"
    sha256 cellar: :any,                 monterey:       "ae171ce02f87e09fa8c0e4e897af7e3eb1e02bb2a0ae364f4f6bc8c4b432d093"
    sha256 cellar: :any,                 big_sur:        "61f4a4ad996a1ecbc5fb8a26850a944d381f54371b1a826b40dddd996b808a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df5ea9150bc47e332e5ff1eb589b53577536db04f20c6700cbf5428dcc5db919"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

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
