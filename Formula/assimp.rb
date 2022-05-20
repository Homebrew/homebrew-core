class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.3.tar.gz"
  sha256 "b20fc41af171f6d8f1f45d4621f18e6934ab7264e71c37cd72fd9832509af2a8"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9961dc6c4704e8755b236aaa77b8dae1f1c1533f167f1f47ed15a7fa89105c06"
    sha256 cellar: :any,                 arm64_big_sur:  "e27cc4e35d08e02ca00ac292cd36c2d4a5513fd6a07be739b38f1ee4cc6ef758"
    sha256 cellar: :any,                 monterey:       "d5faece7848806ffb74c5fed86ee9fd9413cd4dee86f84210cc033cb146457dd"
    sha256 cellar: :any,                 big_sur:        "debb34ddf106651903ab16650d7a52af85f6d3d14f993979d09ec3ecba4df97b"
    sha256 cellar: :any,                 catalina:       "d42b184019a11b425d9c3d14a9080dea21d59e5dfd11f384a901ed76dc6accc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1b396cbf9435fad17fbbdfbf46f8181964c93c72bd6e030dece5cd7a10492a"
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
