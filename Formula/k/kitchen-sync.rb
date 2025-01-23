class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/refs/tags/v2.20.tar.gz"
  sha256 "e79e5dfad48b8345b1d80444a0e992b2f9b9c53f29f6f607647e567292a7d0f2"
  license "MIT"
  revision 3
  head "https://github.com/willbryant/kitchen_sync.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2684885be33f370f74f819981353fa6899910f6bc6217ff89db2ec703a7604ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c29d901bfc762ba6b9a8388856e0f02bb14f22bda35470639fbcca2dad20abe5"
    sha256 cellar: :any,                 arm64_ventura: "2f96d60670814741428174b3b3459b52919437a27b0d2e6dd5649454921a98a6"
    sha256 cellar: :any,                 sonoma:        "dfcac11bf0d2ec89bf2674a869f4a97b260de93ab0d5b6c471b0fb971f11d37d"
    sha256 cellar: :any,                 ventura:       "cf4732bbdb5d936d9025af607d8282362d0db5325efb206ec37c4e307597fa5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d7d9619e53a5f92ae9f77ce8998887682e7cbd89fc61f32665bbceb0699e13"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mariadb-connector-c"].opt_include}/mariadb",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mariadb-connector-c"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end
