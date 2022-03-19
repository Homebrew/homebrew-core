class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.3.tar.gz"
  sha256 "b20fc41af171f6d8f1f45d4621f18e6934ab7264e71c37cd72fd9832509af2a8"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d08a437f78e50b68ff420021c4fc35f26775e11378c6bd56d25f3b39fed6339"
    sha256 cellar: :any,                 arm64_big_sur:  "078891a37d663db330a3a9062721bd24a295b78bc6c7dd84210f5b2fdda94100"
    sha256 cellar: :any,                 monterey:       "91bff527332e30eeec729610e1cf97d61af0e019bcd3f63472f32c43d82c52d9"
    sha256 cellar: :any,                 big_sur:        "89cd2d08ddd01f69aa4c40dbb03053e005a69470b0fbbeebeef2baf2ec31cf95"
    sha256 cellar: :any,                 catalina:       "007d49396d922d264ad37346a38173a988741fcf3953b78436c560f4bee8fccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "219f80b115366e86d01f6514682526d1c2102f3f27318bdf441b924008abc9c9"
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
