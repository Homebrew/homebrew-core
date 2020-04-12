class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.5.tar.gz"
  sha256 "adf87320c4c830c0fd85fe8d913d8aa174e2f72d0ea64c917599a50a561092b6"

  bottle do
    sha256 "d1c5e967c2074d4d19292553da0cdfb360052c1c8c8b63da13ad06100abcfce5" => :catalina
    sha256 "c4f130c4a9c0e9d877b5936c38d77a3129949209074f30971a5a6ea044ab0ed6" => :mojave
    sha256 "c1b06b47e85f000ba6a6c2f3fd745fd9859422b7fc261ec8209a788913fbfe47" => :high_sierra
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
