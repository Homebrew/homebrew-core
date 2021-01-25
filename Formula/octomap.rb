class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.6.tar.gz"
  sha256 "0f88c1c024f0d29ab74c7fb9f6ebfdddc8be725087372c6c4d8878be95831eb6"
  license "BSD-3-Clause"

  bottle do
    sha256 "fd9d3306fd3baa8c19a330c1deb9683a83572fe7dea71abcbe368ed5e9e90a93" => :big_sur
    sha256 "484725230dbef1b0cb797a649219f481fadd4ac9841ba38d1e841dd4adbb0d77" => :arm64_big_sur
    sha256 "5e914c7f5e2f0fa183fa8f0bd24508170162b5ae62fbb7b7672c18a36787c8a5" => :catalina
    sha256 "5e019f4a11c0098d6dd0250fae94038946417030be84fea8b2bb65cc145440b4" => :mojave
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
