class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.58.tar.gz"
  sha256 "56c39c55d9db5576adc2197cbf2c0cc79b77c5a225d53b7f0b4c2bd9d1f37590"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "bd1246587e299eb8cb550d39f3b79d6ddc9768be1bdd3a0d50e7f5253a66775f" => :sierra
    sha256 "892fcdbd9ed3237bf19bbfa80abb28ddaae5f8330a8e5ccf08599003aeec46d8" => :el_capitan
    sha256 "e85f5c937b26cf7569b56cc31132658dfda143ffdd025ce2738d4cd0be92c300" => :yosemite
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
