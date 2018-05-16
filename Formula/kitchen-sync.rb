class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.99.2.tar.gz"
  sha256 "111571265037d48441f4c3a7e3139a9ca445db4a95852f3cd9b15b81e573a9e1"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "a51a243423e32bf11e378e0f330b3c9a1cac2fa75d97ed6e8e8c5d548b705456" => :high_sierra
    sha256 "1381e6f52275a1362e89c1e006b25d3e3a05077ffdfc465cbf9ef21b519e3e9c" => :sierra
    sha256 "d72d2d008620c822dc4ff6164c1aa25eb51b34a171f9946b55c7eebd2462b051" => :el_capitan
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
