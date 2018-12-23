class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.9.tar.gz"
  sha256 "9e2dd1200a8bc0711bb69b9f0aa1e4aa6a3c0f7661f418f2b0db02fee0ec1059"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "4227a35d5b9109bcb2d8c70e7de1b37b5411abd916346dd0492b86a164f262b7" => :mojave
    sha256 "2f5925e2a5d1cae5b6f8f189d047c215a9eded17cc92e4b397462e500a5f49b0" => :high_sierra
    sha256 "ce3535aa21e46e275900c08e9149742642c511cac546bfa967e3fc7afc822706" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "mysql-client"
  depends_on "yaml-cpp"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
