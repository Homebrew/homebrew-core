class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.6.tar.gz"
  sha256 "52ad3a3776ce320c8add531dbcb2d3b93f2e1f10fcff5ac30178b09ba934d084"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "790c05f8a6513c34dc23027baf63e062c513d5ac239909de1051c1af54d4555e"
    sha256 cellar: :any,                 arm64_big_sur:  "798a33c8c91585acce13419a52665b905ab14806085d41a4eb42c69afb338e61"
    sha256 cellar: :any,                 monterey:       "95e27885dd0291bbb5a14d1b51669b3c7ac4fd3fd06ea20363e76d0005a36d9f"
    sha256 cellar: :any,                 big_sur:        "ab53d489c2ab05e8936a4a20f54dc02ded2ab5768b6889abe6c0e1e866fa47e8"
    sha256 cellar: :any,                 catalina:       "659213cb6fba653c1a0edd5e32821ff5e1ae28edf10a13e80b9d6abacd2631e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "111a95a9081d41ac038247828e652ceb3fb8d47545daadae58b36d463f2c0e5b"
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
