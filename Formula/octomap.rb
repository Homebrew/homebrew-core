class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.1.tar.gz"
  sha256 "9abce615d9f3f97a15ba129a10e3a01f9bef9aad178f2ef398f9a925f793c7b9"

  bottle do
    sha256 "5c4e53e0a23b76ad71f3c8a74118d9538ea1871e90c034ed1a9d2b75f60fc8d3" => :catalina
    sha256 "a4d0d866ab76835817fdc0dcd1b3bb1cf9248e338223aba24af680daf53d65c3" => :mojave
    sha256 "9432c0567beb3f4fbad243670cc65054421383dbd07e78faaaff109032a435e5" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    inreplace "octomap/src/math/CMakeLists.txt", "INSTALL_NAME_DIR", "#INSTALL_NAME_DIR"

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
