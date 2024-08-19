class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "7414861a7b038e407b510e8b8c9e58d5bf8ca76c9dfe07a01d20af388ec5086a"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c168e1d0349dd0e5cd2261013fd1ddf83b7162c53295233df9b33447e8735b32"
    sha256 cellar: :any,                 arm64_ventura:  "f5ed4f2c77ad77d6c7246db39f1ecf65fea03504bddf5d258b1d9a338d6fbc6c"
    sha256 cellar: :any,                 arm64_monterey: "5d64d2164c01dcec92b862943752d92d9b63aac79c01e2006639e049e6313b88"
    sha256 cellar: :any,                 sonoma:         "6aa4182e7270a1696c563f2bf5b1546f1cc99c1565617939cd940093c02c7546"
    sha256 cellar: :any,                 ventura:        "26e5da5f20451efbb53acf14c49a86bc808709de43873b17dec17ca0695e06c3"
    sha256 cellar: :any,                 monterey:       "6166c69552a604d94a90a1e1cbb66114eed19e1ad69fc47cbe7c4d2801d8350d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f738db0e08a015e5f450e04c01e61c6d57dc5107f617eb3bf30ba69a66796f05"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = %W[
      -DASSIMP_BUILD_TESTS=OFF
      -DASSIMP_BUILD_ASSIMP_TOOLS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", " -S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
