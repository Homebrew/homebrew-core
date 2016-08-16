class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.54.tar.gz"
  sha256 "edc2539e80965be64a62db7d44e7914bba465fc3853ebb04f93a9f0c817dc693"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "dd9af539436441a17b9a11868ff599a24ae90c15313d52fff48398d06fd78cad" => :el_capitan
    sha256 "b6a9636e00f2d3e79eae34f32a53751ddd205b1661dcf4bc3c61fd41f40ac0fa" => :yosemite
    sha256 "d70bab51bb8f803546aba16c63097a3ffc334282caa8bbecc955c8cb21beff37" => :mavericks
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
