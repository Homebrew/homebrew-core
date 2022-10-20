class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.5.tar.gz"
  sha256 "b5219e63ae31d895d60d98001ee5bb809fb2c7b2de1e7f78ceeb600063641e1a"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "425d606455cdeb33666e68e04622f91db9bddf05c2c0c1bcddc94549ea05501d"
    sha256 cellar: :any,                 arm64_big_sur:  "99485501be944e3bcef0503cab79cc978c69e6e168e65ec372699f758e8928d5"
    sha256 cellar: :any,                 monterey:       "f8890abebd50f73b75dbfad26d160bfef00d974222afa715fbee0b4ef5ca223b"
    sha256 cellar: :any,                 big_sur:        "66efffde726aaa05bf365db06c1aa47a4f5a383d15a0b11b260c8137d005ad4b"
    sha256 cellar: :any,                 catalina:       "46d4f02acd656c9c076ae7746a436256e8dad06749fba35ddfd9a4e1769be7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699adeee9696cfef9b7ef986f43c2930c6d9a8d686915b8e1a021386aaa95175"
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
