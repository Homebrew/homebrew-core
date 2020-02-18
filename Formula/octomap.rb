class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.3.tar.gz"
  sha256 "8488de97ed2c8f4757bfbaf3225e82a9e36783dce1f573b3bde1cf968aa89696"

  bottle do
    sha256 "5c4e53e0a23b76ad71f3c8a74118d9538ea1871e90c034ed1a9d2b75f60fc8d3" => :catalina
    sha256 "a4d0d866ab76835817fdc0dcd1b3bb1cf9248e338223aba24af680daf53d65c3" => :mojave
    sha256 "9432c0567beb3f4fbad243670cc65054421383dbd07e78faaaff109032a435e5" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    cd "octomap" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <octomap/octomap.h>
      int main() {
        octomap::OcTree tree(0.05);
        assert(tree.size() == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}",
                    "-loctomath", "-loctomap", "-o", "test"
    system "./test"
  end
end
