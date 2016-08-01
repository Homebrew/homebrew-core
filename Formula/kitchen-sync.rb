class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.53.tar.gz"
  sha256 "47489b0e2de1147069e9af7d48206839e1fedabf4446581587476654f5ab709d"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "d33cfcc2f9929693f6b8f14a532538516967e880b65bc5e1f2a06b0ece322d1b" => :el_capitan
    sha256 "5abe68abc5a10ab276dd860f793386ff55231433206430a5b0fe636441c98095" => :yosemite
    sha256 "a16decbc9c92076204f4ac0759bef20766f530ea538c11686238a699fa93e0ac" => :mavericks
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
    shell_output "#{bin}/ks 2>&1", 1
  end
end
