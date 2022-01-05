class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.14.tar.gz"
  sha256 "bcdcb1ea70ed29b6a298782513edd29b5f804b19c6a4c26defdaeaabc249165a"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fbe3db4c61e451e5dbe24d5bc139e44ce2ab5e25cec3b0f39c0058e16506be4c"
    sha256 cellar: :any,                 arm64_big_sur:  "90f88952a6375ce660f96ae550f43c61ed744f4bf006188973829836b9825625"
    sha256 cellar: :any,                 monterey:       "80768411efc51a726d4583857937a4d8b01bfb21b9c3d49294fd7976dd64135f"
    sha256 cellar: :any,                 big_sur:        "40ecd4839e8893ab3b9d16c1cd6bca6fc785d5de357f41f029139b8d8bb02550"
    sha256 cellar: :any,                 catalina:       "1d7b02016595ac0f0169e19c45c3935d1231ab6142a70faa3ea504a01b36f22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105436e926b0cf71258194ee57934c1c081611f1be75e8276fe0f9fa3e31cae3"
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
