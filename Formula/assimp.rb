class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "http://www.assimp.org"
  url "https://github.com/assimp/assimp/archive/v4.0.1.tar.gz"
  sha256 "60080d8ab4daaab309f65b3cffd99f19eb1af8d05623fff469b9b652818e286e"
  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha256 "d604ce94fedd5b30a5ae53d22e1573ba01b9295ddf6b52b008bd33c0a7f3b105" => :sierra
    sha256 "aa26fee8bb1be4488b5f16d29c78fbfb7a74fb5b69895ce62baf6184d11c38d9" => :el_capitan
    sha256 "68cf888a4c7119388707022099a16daac509a791b52c1617cca53509049812a1" => :yosemite
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
