class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v4.0.0.tar.gz"
  sha256 "9025d7fdd2a1d1d23261cbbcb1155b267f2a277f7e86103e5e16f1cdea407fb9"
  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha256 "33f1c8829b765b1cf2617033283c8327be4fc56aa17195d905be9e2293ce7ed2" => :sierra
    sha256 "44b47fc2ae6bed6293413ee01c15e009a7c1cd89b34cb999ae78140b1cf1f70e" => :el_capitan
    sha256 "0a6c9c1ce1f58f930a52842e2451f26c9dea4bfb7c71cba53a1c2f41e9158b87" => :yosemite
  end

  option "without-boost", "Compile without thread safe logging or multithreaded computation if boost isn't installed"

  depends_on "cmake" => :build
  depends_on "boost" => [:recommended, :build]

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<-EOS.undent
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
