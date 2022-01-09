class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.6.tar.gz"
  sha256 "52ad3a3776ce320c8add531dbcb2d3b93f2e1f10fcff5ac30178b09ba934d084"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a99e86efbec29439561547b70297d6d9a71e88224cc70b1d7e203d3930eb6690"
    sha256 cellar: :any,                 arm64_big_sur:  "f3f76d024fa71756b33beb77bf4d31f7f10fc874f7cc6c6c4b89aaa43946facd"
    sha256 cellar: :any,                 monterey:       "68fb02a8d41b9db3ef1e98f657e1f32eda15e154e8d608f058b1799d9d0cac32"
    sha256 cellar: :any,                 big_sur:        "5f778dd6bc8d06022df0e054fc528cacaacf4ce68ce93cb44c26f6479556cec2"
    sha256 cellar: :any,                 catalina:       "5ac51c9fce584adc69cad8f24593cf153b76fe7a825596a3dae7dea934aded8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e738d63c7018771a4f10c62328ccabacbdcdfb6cd6250a72fda1a126e773090e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -GNinja
      -DASSIMP_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja", "install"
    end
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
