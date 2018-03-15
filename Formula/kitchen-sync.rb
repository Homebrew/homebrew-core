class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.99.1.tar.gz"
  sha256 "895b710f10e9399ce8e49efe1b24ca925b4a62510d817a0e4b60e11c4cefcaf6"
  revision 2
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "49ad47bba862b6c73727cb6f0d0d72725c961e6003eca4a81633b31d1f0b5e99" => :high_sierra
    sha256 "305a5c37197e113074c4ba61265ea28fde9c7560531032611e380ca3204d1d34" => :sierra
    sha256 "30846fdf73486d98d69d3361a7329a89717e2cb81f3531241ebc4b2dfa2174a4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"
  depends_on "mysql" => :recommended
  depends_on "postgresql" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
