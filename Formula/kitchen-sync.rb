class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.60.tar.gz"
  sha256 "29163aed9864a82b4a821d17687e11c05b445f12ab199069b642c4a7ec9ab030"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "fbf63628537afa3e7dcf67c2cd6371ddef35822eb1b90493e6eada652c7ee7b8" => :sierra
    sha256 "fd58b6f5e7f13264a5fd3eac850207af4b29ca8d4a7eed4f78721d16edfb8f3d" => :el_capitan
    sha256 "ccbfae808700163a8b7074fef1f7673ae98c448c23a34f30ebf724e3b0c4465a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp" => ((MacOS.version <= :mountain_lion) ? "c++11" : [])

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
