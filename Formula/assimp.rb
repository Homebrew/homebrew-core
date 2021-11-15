class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.0.tar.gz"
  sha256 "b96f609bca45cc4747bf8ea4b696816ada484aed2812e60ea4d16aae18360b0b"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e1f22dfd8a8bbd6ab3f692177fd9a2435969a8f0e14f515fbd25a2b98ea3b15"
    sha256 cellar: :any,                 arm64_big_sur:  "bcdea74b9cd2b2344e773cc0ed0865216132119f3c2fd7844b8a064184bc6d9e"
    sha256 cellar: :any,                 monterey:       "f2b5937f1243dd994ac57951d1086e51c4a040c2e77353cea0968baeb1c03266"
    sha256 cellar: :any,                 big_sur:        "dd57363dec3619597205a235b28a53a550e5e550309ef40d9574ea766b6c222b"
    sha256 cellar: :any,                 catalina:       "303ed5431ca71851d1cb6e9596c433b73cb0a7873fd0c1142da5dd5096749ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b97335f990b541169235a5ca78ed96b9d974e6035831169f2ffeebff30dff01"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", *args
    system "make", "install"
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
