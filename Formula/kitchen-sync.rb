class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.56.tar.gz"
  sha256 "ce6915cbfec6f0072ce028ace49d6ed6809864bd7fd729be7c2a3b03e1cd9edb"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "3fa3355ce4c6b9000a5b65fadf94ab465d5bd3fd9f90cd56188152131c04b7d9" => :sierra
    sha256 "b81ff335ec0227e4b5a167da5f3a5463266a8530bf133933ea4fc8e63d0170cb" => :el_capitan
    sha256 "6019280d1f6630f76acc2cfb526c7e67b1ca1094e8fa0508558e65140682f620" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp" => (MacOS.version <= :mountain_lion ? "c++11" : [])

  depends_on :mysql => :recommended
  depends_on :postgresql => :optional

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
