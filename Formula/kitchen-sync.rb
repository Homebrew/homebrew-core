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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "04a1641dfb0b1188987f5bbb49c7708d1d165d1e2179ed07c37e2f0199203287"
    sha256 cellar: :any,                 arm64_big_sur:  "00a906e98f06b9577ccae18a4152d89801417710402a6eec10e0996a4cb8c0e1"
    sha256 cellar: :any,                 monterey:       "9699999584d43aeb1cdcc4b9ae0fe69998cb582ba07e26a6db38883fa7842b16"
    sha256 cellar: :any,                 big_sur:        "1c3eaed8e93dc06f9b540d5fe7bb4aabdde1dd277ea6cb36fbe147fff1e6d254"
    sha256 cellar: :any,                 catalina:       "9a35f320b636b7e49d27e0d41a348cbb648da45c60f74eae9cd96c13199f4e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cff3e9089058f7db2fb7ddfa55fd97358fa9b207265091ba73a756ea0baa5e3"
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
