class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.58.tar.gz"
  sha256 "56c39c55d9db5576adc2197cbf2c0cc79b77c5a225d53b7f0b4c2bd9d1f37590"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "bae5fb16ac4c9891d89acc5c7eb3f6c077dce957a6b5a03bf9939f8c55c50c38" => :sierra
    sha256 "e756f876f5332fb3847fee2ce4f22505638f3c8d4172423b8719feb14fcbff36" => :el_capitan
    sha256 "ef9031b71673148beeaa0442d9bb92b998575a4801b583b22a14e3035b3372c0" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"

  depends_on :mysql => :recommended
  depends_on :postgresql => :optional
  depends_on "mariadb" => :optional

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
