class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.0.tar.gz"
  sha256 "5f81c9a8cbc9526b2e725251cd3a829e5222a28201b394314002146d8b9214dd"

  bottle do
    sha256 "ebcc39c4935eea656d1c9b3f4f8e4360b2cf559255cec9d84c8cf22d0ac6f661" => :mojave
    sha256 "3e72d0af26510eb79310138dc80a2b2dea541e90ac58a953e5294251bca14728" => :high_sierra
    sha256 "eb292c0c7005c2fd75b65f50bc2a361181ee7c3c5113f6da56f80b4f03bf75fc" => :sierra
    sha256 "d29abe7987fdb2901996e8e6c4aaf2c8a0daeb98b6cee2a585f048769082a4ad" => :el_capitan
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
