class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.17.tar.gz"
  sha256 "1f6296ca0c9dcd9bb7944aebb8148ab3e857ef76b3dc2f74337fbd0d9edcff80"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddb84094f83bd102d1265bed95a3a89a49c80e9f54c49efa33ca9b2d0d540617"
    sha256 cellar: :any,                 arm64_monterey: "57bfe600076a6e201187e23964fbbe838da403432fa1c5f1e87a70a669caab61"
    sha256 cellar: :any,                 arm64_big_sur:  "3fffdd7af0375625a2682cddd3e42df50c75f8df4831f105562a64ce1a709707"
    sha256 cellar: :any,                 ventura:        "b42f537f2b0a2159d29dd39310c8d2ac316f8ab516e0f7979b4fc9b19a7d467e"
    sha256 cellar: :any,                 monterey:       "f37f1ed67b54da5fa4a30549b3162138569c7306fd8d3a18e03c486cd11f7ee9"
    sha256 cellar: :any,                 big_sur:        "60270754c4e413bb7add2d8104a925fc40a5920ebb0614cfd4ce852c00dc3fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90aa8d03966bf367921a460cdb10f42e89b98f44a11b12b94af0a12549727fd3"
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
