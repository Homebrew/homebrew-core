class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v1.13.tar.gz"
  sha256 "ae821ad4da83745dfd49f983b5d77827a3a6d72ac50b6e5fe2852532a0c81f97"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "694e6e64589c066a17765c25913c1fa55c2ea40e04a2da288c972842b80d54af" => :mojave
    sha256 "fd04c3e1ff17eaaf5dce7f6295ee5352031e889cbd00de0bc2cb688c43ba8e42" => :high_sierra
    sha256 "eb900c023af28717d05fc2ac68bd0e629ca8e45dff5f5280535e05c55e4c3bdd" => :sierra
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
