class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/refs/tags/v2.20.tar.gz"
  sha256 "e79e5dfad48b8345b1d80444a0e992b2f9b9c53f29f6f607647e567292a7d0f2"
  license "MIT"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f8cf7d2864d228a9dd683db4e4db77e7bd26299a27e57123de0024e49dd4cd9"
    sha256 cellar: :any,                 arm64_ventura:  "e6ee691c1832150af1dc3a2107575d9eb4e679408bbd389ad8300d47e8aaa77d"
    sha256 cellar: :any,                 arm64_monterey: "47bc5d86d010b784a109329b79c58369482dcd69a533cdcdfa1917b1e75e93f4"
    sha256 cellar: :any,                 sonoma:         "e5b1253868e365244a55b34082af8f6652235d7dfdb701524a0209811b317395"
    sha256 cellar: :any,                 ventura:        "21339399ddf59afa015707b5b746885a1ea63fce3ec5129999126af9c5297502"
    sha256 cellar: :any,                 monterey:       "2e2a97794f7b569203f4d175ed72a23ca4bf97ec120777ccf1a55fa4f7be615a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e328803005bb943025c372d5e2c3af128776606ea36538693f80d4af6e3ae8"
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
