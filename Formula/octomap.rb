class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.5.tar.gz"
  sha256 "adf87320c4c830c0fd85fe8d913d8aa174e2f72d0ea64c917599a50a561092b6"
  license "BSD-3-Clause"

  bottle do
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
