class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "a1bf71c4eb851ca336bba301730cd072b366403e98e3739d6a024f6313b8f954"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c519a97c6544a8b848130ed1ba4301563e7a88792e8a7021b2dded16d17f159"
    sha256 cellar: :any,                 arm64_ventura:  "e4297dc654c067e5590b95e1736afb2f9f8a606e543092ba9e1e4834c16b7eb8"
    sha256 cellar: :any,                 arm64_monterey: "046197638478526fdfa3217dce5957d5f27b835953a77a355313eb9dc5bbaa9e"
    sha256 cellar: :any,                 sonoma:         "184a8a0423b053a30a3118e81052d42faed4b793be472cab92b938db828355a6"
    sha256 cellar: :any,                 ventura:        "b4e5ab92c7c7f120da5a9eeed35e5b015a6388644681252a03193b8175bd96fd"
    sha256 cellar: :any,                 monterey:       "b6d04c67b353666867540bdc5080795415514eed926df79cdd9c4c9feba88d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa51e97c337955b5a829764880138d661b1d8368b7a26b9245616a2198a79e84"
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
