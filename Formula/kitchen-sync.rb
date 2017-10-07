class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.99.1.tar.gz"
  sha256 "895b710f10e9399ce8e49efe1b24ca925b4a62510d817a0e4b60e11c4cefcaf6"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "7a95a1a947e876169f2582f1bd5ae695f1aa47f4b7b47243db16afc535dff6d9" => :high_sierra
    sha256 "2201aadfff95b4bf3e72d34ad626aaf1ccb86b8678b5b72ee99372ec98eefcf4" => :sierra
    sha256 "83dc8312a57ed7dea181a9289bca96e56e358dce031732a75738b2ac3c680d2c" => :el_capitan
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
