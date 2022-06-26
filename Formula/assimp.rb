class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.4.tar.gz"
  sha256 "6a4ff75dc727821f75ef529cea1c4fc0a7b5fc2e0a0b2ff2f6b7993fe6cb54ba"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67d6e7b43419f11e105b6ac7e4a147ce07aef50b933c41fbfdf02382508abff5"
    sha256 cellar: :any,                 arm64_big_sur:  "7caf721e862862f3c4dbcaba048fe8707368a9ec148b7ec578ee34cebaaa3455"
    sha256 cellar: :any,                 monterey:       "f5fdb9347de7b36866ac711c002366412971219d02c365af91fd7a620f9ab88f"
    sha256 cellar: :any,                 big_sur:        "b9402a7cc394876768c95b76e4e9893ac32a2c0dcd7c4ce893e77ba6582d91cf"
    sha256 cellar: :any,                 catalina:       "f0b432d116da9f388c812fdc39c05dfe8bab467f285b4046f29023a3bee2f073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3489f9eba0842af02276b74aec5da76188f48b5d13366c9cb0a69e36135a27f"
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
