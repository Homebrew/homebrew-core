class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.0.1.tar.gz"
  sha256 "11310ec1f2ad2cd46b95ba88faca8f7aaa1efe9aa12605c55e3de2b977b3dbfc"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git"

  bottle do
    rebuild 1
    sha256 "1a4511b5f06aa0e9d579b72af3aa4dd0d43b93860d17dfacfab586ca2947d1be" => :big_sur
    sha256 "987d2ce0acc2fbfd488f82ce67c0eb47845f8b0a832cbae8c7d1a2090e81ada3" => :arm64_big_sur
    sha256 "28224c17d5d250055b39990a54de9e744f30b59950ed12d2a08ff0192d029c0c" => :catalina
    sha256 "85dc308dfd468a6dd66978d890106b777829b7b4a04970c395c04aa832ad4931" => :mojave
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    args << "-DCMAKE_INSTALL_RPATH=#{lib}"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~EOS
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
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
