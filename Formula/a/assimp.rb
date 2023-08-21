class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.5.tar.gz"
  sha256 "b5219e63ae31d895d60d98001ee5bb809fb2c7b2de1e7f78ceeb600063641e1a"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "38267be8c3911c4269de574dbb3f7a95523cf3eee9a37867900e35c62304d72a"
    sha256 cellar: :any,                 arm64_monterey: "41d4dac7a778c2ce90ac37fed8719342f01955f853cc5f22e003039cff473706"
    sha256 cellar: :any,                 arm64_big_sur:  "3193797fdee877db77e530640ed40ffaedc4faea785e7fb635a33f8f53276cab"
    sha256 cellar: :any,                 ventura:        "df603dc822f5590620aada3ec00d52e3d4f701ed2ec5dba6c3fd93674fa10ba8"
    sha256 cellar: :any,                 monterey:       "45a132fbf709f176c786bc68d46762278bb1becb970af8e1c6eae57536d549fa"
    sha256 cellar: :any,                 big_sur:        "9e9aaeec7e775d4dabfa0bd8fdd7829e1fe41052ffc94e1463012a9c4a0991ab"
    sha256 cellar: :any,                 catalina:       "36735fe1df202f856c7a30297b99283497ad7bb4d48e95aca55db30c03009084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2014dd56de28ba603d88dc9df9744569abe50b62d631e2d78e0a08f8e9ff62a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Fix for macOS 13, remove in next version
  patch do
    url "https://github.com/assimp/assimp/commit/5a89d6fee138f8bc979b508719163a74ddc9a384.patch?full_index=1"
    sha256 "a5fa5be12dd782617d81cc867b40a0bca32718fda0c6cedcca60e2325de03453"
  end

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
