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
    sha256 cellar: :any,                 arm64_monterey: "b090e8487ec4755755e726638f6d23e1146c63bab3abdca1abfd9eb5729a9c9b"
    sha256 cellar: :any,                 arm64_big_sur:  "b66ded8959d88193f30ed3bd7cb3dfbf81316f6cbef82e77fda85e227772cb40"
    sha256 cellar: :any,                 monterey:       "5106166e0e08e91b0703c38bce5e864cefd09ce016f91e989a895daa22c4796d"
    sha256 cellar: :any,                 big_sur:        "d02d2abaf4098fb1fa07bcf8a28193ebb762409a010d20be595706205d69a886"
    sha256 cellar: :any,                 catalina:       "d452e4f3e29836a4919108df9209af24a58562c77dadc46e47900fd63c78e840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a073dc3cf0f4db1a641de2931020ef4f27a4db5416e907ed53233ddd937a5f37"
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
