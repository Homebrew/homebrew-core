class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.3.1.tar.gz"
  sha256 "a07666be71afe1ad4bc008c2336b7c688aca391271188eb9108d0c6db1be53f1"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ceed09a9c989320467f6b90692caac628c8313dcfdad38e6291170b1c98e66a"
    sha256 cellar: :any,                 arm64_ventura:  "515d5b7dde63fc4dd6caedda233dfa167a99b27210458fc24024e34edaa30d47"
    sha256 cellar: :any,                 arm64_monterey: "4cc557c50f89eba7285ab3b063794bfee8a4347b78f600828d507d0104b980e4"
    sha256 cellar: :any,                 sonoma:         "e7a655610580754fe998dd4cac699179b19a746b08c1518d6d20c0b2ecfce883"
    sha256 cellar: :any,                 ventura:        "b5ca674953b7bbb359e4816a2f815f8003fa10316557f61bf248d30ca4d165aa"
    sha256 cellar: :any,                 monterey:       "af9d24b6b60cc4c589424f9b915333cd93bd18ad14ceba741e5a182f8c8e2469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "299b844069a58a807eb89b28dc413f17717037502b129f8281044effe4de785f"
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
