class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.5.tar.gz"
  sha256 "d62b58ed3b35c20f89570863a5415df97cb1b301b444d39687140fc883717ced"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa5a269ac802e385376c0de0af7019864da1e6dae9a0d6f65485dccb518f43b9"
    sha256 cellar: :any,                 arm64_big_sur:  "81b6312f58dfbdd6611f43a4782bc3d0d3c0d7c8534f7e40a2fad130234794d9"
    sha256 cellar: :any,                 monterey:       "d2857defef10d121616cce336b5443a423394d45e0f5cb7fa4d975d4d91a691a"
    sha256 cellar: :any,                 big_sur:        "ac7d433ca00be882f7a0489d69248c0f1413ec30a519e4afb287043ed4b560ae"
    sha256 cellar: :any,                 catalina:       "2ad63a74103190737d5b050d7d5c42b885816cc4d1cf238d4987129f13b70dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb66561277fb9773740eac91af3555320b277b37eda59c72a2d2fac449156b6"
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
