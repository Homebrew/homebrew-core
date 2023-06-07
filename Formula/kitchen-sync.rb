class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.18.tar.gz"
  sha256 "088908d9a2cd5155245cf7bf8823859b0cf7e8901c5f97843c863f8e344fdc5b"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da1ff72fa652658d29972c4590c9920d25dd02b2aca5446d8cdac0d978101970"
    sha256 cellar: :any,                 arm64_monterey: "bd788d9b4bbf2cc1d858cb70fc32f2854ee953e9870b5c93c77271f50a6cf2d0"
    sha256 cellar: :any,                 arm64_big_sur:  "11da7841ee23266a175f6f301da1b53cc7c17cae9ea7b27c78e8338e8b7ec40f"
    sha256 cellar: :any,                 ventura:        "a6f43868f715d5852c23e39ada1fad15ad2ee23aa5f25861bd861accd5097da1"
    sha256 cellar: :any,                 monterey:       "4e677bd8bc05191b5cc7441f41d1fadf3ef509bd662708aef438396d3025d2da"
    sha256 cellar: :any,                 big_sur:        "47e297ac9e1f0593912c5add644866577122d121f97fa509da2c4dd266147ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f0c80cc34eab39f9effac63c33bb154e257b2a3ad3ef65be1553adf170fb26"
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
