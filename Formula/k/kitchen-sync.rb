class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/refs/tags/v2.21.tar.gz"
  sha256 "0a2c25001069c90135a91b1cc70c1b9096c3c6e127f6a14f1b45cdbb0c209f09"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1541f10205f1f95dc6c3e77553abf9292dd90889a1ade99bd3e9ec7242c5be21"
    sha256 cellar: :any,                 arm64_sequoia: "7a4ef7280430f9a4bf5464e8b516f53af6eb9e8307cd5070b9d51e4373be601f"
    sha256 cellar: :any,                 arm64_sonoma:  "12c2064e9e97f09562912a635453b0b015071117ae19062ab3cd804435139072"
    sha256 cellar: :any,                 arm64_ventura: "541760108930e985207dae586caeed9aeddacfd348295a5f5af26bebc225246c"
    sha256 cellar: :any,                 sonoma:        "d5c53943f1d960045b1fbd64124d2004531f9c046b3ed7cae5246b4d813c0cc5"
    sha256 cellar: :any,                 ventura:       "d73ae2d23fd13510fd8b6fba2130dd2761587cc505866a8e2bb4686be1d14ad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb7f3f8129476eec9257b88dda07e647af4209af5784b9b3758a37e95786f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7884a6d66df364341ac6ee59613ed1a1198f8171fbb22a53f2849194cf4ac728"
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
