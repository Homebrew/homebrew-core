class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.2.tar.gz"
  sha256 "82d17f65fdc90acedd52dab52e30c0920445e45fbdedc88dfc6154f17902df5d"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "112496221f7512274f46170b41765a2e933802e0e8bbc612715fb30dcffb54f9" => :catalina
    sha256 "62925a19ef8b0bc3dd701cb392cc41b21079af0b47ea978d9c9e2870ec725d05" => :mojave
    sha256 "9ccae36b21cc293c6db76a5974c4dc313d2e9e25659c5b067cc56082cb0b2ff6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

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
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
