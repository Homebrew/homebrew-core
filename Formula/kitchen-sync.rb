class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.56.tar.gz"
  sha256 "ce6915cbfec6f0072ce028ace49d6ed6809864bd7fd729be7c2a3b03e1cd9edb"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "fe5efc1e99e15268b9a7de23e4a62b0f1e34f93f26d5c9de1762cd8a6ee9d671" => :sierra
    sha256 "f29d51e4381340ab4f9010af3069ddcc505da572a30542edbe0642962a3f5b79" => :el_capitan
    sha256 "c9f5e0fd483d304a5e41439385be857c5beb67379793e14864487277cca347b0" => :yosemite
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
