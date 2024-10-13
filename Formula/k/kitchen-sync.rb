class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/refs/tags/v2.20.tar.gz"
  sha256 "e79e5dfad48b8345b1d80444a0e992b2f9b9c53f29f6f607647e567292a7d0f2"
  license "MIT"
  revision 2
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3a519761b19188c855fa856eb3d17351fc10132877a4f2eb4791a89a0a0bef37"
    sha256 cellar: :any,                 arm64_sonoma:   "a4429aa5f1ee46f1d6c0405bbad656a787be6258d7d212ca528e6122155b91af"
    sha256 cellar: :any,                 arm64_ventura:  "bff92ee576a17d3a49e9995fd0b867f1f38c9370deccd4aed62100a14c8348da"
    sha256 cellar: :any,                 arm64_monterey: "e6a926959adfe33034c7b1f4b2dabcd2dfe4cd7f3a75b765c4da2e7fdf796586"
    sha256 cellar: :any,                 sonoma:         "cab7d1d6d57d75a9d61778bc8e0751769c02d6e4d8e1c08bdd3d51e8b262423c"
    sha256 cellar: :any,                 ventura:        "383c6f4945cadac4a243b6004e8bb6ee48e0173ecde263e22fc19df092f3f590"
    sha256 cellar: :any,                 monterey:       "c3260fbd0437006a26c353ad2ae50b0440279054361e6d7f2a3f248755462dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d02052dbe9d79877a1f9bf2765279cdee8ee9e14f0bb50dd345b9574ef433fa"
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
