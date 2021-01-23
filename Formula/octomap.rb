class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.6.tar.gz"
  sha256 "0f88c1c024f0d29ab74c7fb9f6ebfdddc8be725087372c6c4d8878be95831eb6"
  license "BSD-3-Clause"

  bottle do
    sha256 "61071dabd01169f7677c8a3794920719f5d746b261c52ec31f087d2c9c1cd407" => :big_sur
    sha256 "ccd5bda09d82b445cec55b443429d18ac9c5567c73f69b1e1a42d190b6f49653" => :arm64_big_sur
    sha256 "dcf938ee253a527143d78cbc39c20046015519b5aff741656016f0a67ff705b9" => :catalina
    sha256 "878681f950a14d49b47bd69605a12bae4f42f127b4cc7750de14b7a16f6a9930" => :mojave
    sha256 "92def71d469ce8d5a660d371eded16f8d25f9346e2fc3f34ffd105f3bbd2060c" => :high_sierra
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
