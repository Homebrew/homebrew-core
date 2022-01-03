class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.13.tar.gz"
  sha256 "32e2a81cfa802d14e874fcb3264ccb9c7355519bc90ea5bcfd9edd8d91935533"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc5f36e9375c29d9ca7f215cd8ace4fcb5fcb2c9d5da0a9dc120c24427337970"
    sha256 cellar: :any,                 arm64_big_sur:  "f3ce2adf5dbceafb92a9f5dcce4c2ad9b49b7e1c063c30d219a58b83cdbc7309"
    sha256 cellar: :any,                 monterey:       "1b39cae1a4938700f4d7260958a41067142f43ee9b08404f9164a3f92e8fe2da"
    sha256 cellar: :any,                 big_sur:        "49156b61e811b96df1579182ae8fe03afda6168fe57c8e981793ca63928abfe1"
    sha256 cellar: :any,                 catalina:       "9faac700097c68efc2c4e55b30b450970c81b9f94f8ae79b446aa3c19ef0c827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a25d0e969e251d5ad054fee8b57cf0f39aa2c30b761d93f206b643742fda166"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # remove in next version
  patch do
    url "https://github.com/willbryant/kitchen_sync/commit/8a160b46ff8e35832e9a4c891dbc50706ccba95b.patch?full_index=1"
    sha256 "eae7c668242a8505fe9648d5a2b25ec974ff166f518548df3ff53851a4426473"
  end

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
