class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.2.tar.gz"
  sha256 "ad76c5d86c380af65a9d9f64e8fc57af692ffd80a90f613dfc6bd945d0b80bb4"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44c4e13b16d7cffa948df7c1442c0c7be054911b7f9b6e161bc3f0987bd7cdaa"
    sha256 cellar: :any,                 arm64_big_sur:  "139aa86482fa6d1f320c77b36847a836ca110d2c5c115f43dac125478182637d"
    sha256 cellar: :any,                 monterey:       "e8403630f88560db95a5e085341c9db76753872216d886fceb80a0140d60dfde"
    sha256 cellar: :any,                 big_sur:        "9162c3861e6efb53bb302a40327806befca6c2cadffac36161254c3161f23f53"
    sha256 cellar: :any,                 catalina:       "4f9449dd1cc9acc476256cbc95da35f0e3fe389ff5b8229c61dd82ca18dac45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d451693a60fdecbf7c4f797389ac3eb01c01cdf79c46affd05f56f2635a6d5"
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
