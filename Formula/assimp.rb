class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.2.tar.gz"
  sha256 "17aff648d50dfd8fd07365684fe956812673044d759cfba28f8112bf98a2be7f"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "664b9253ac3b371705a4764f8f74084efebbac1c558375c182b14b61f9776397"
    sha256 cellar: :any,                 arm64_big_sur:  "412196bf70298614c768a1aa0bf3c09c2a496721c34157206a2e2c6b97105131"
    sha256 cellar: :any,                 monterey:       "6c6c2c5635d50a9b4c7430b63b2297634c63888f6cc29fbeef48ecd44eaf2c01"
    sha256 cellar: :any,                 big_sur:        "c2c0d009713226012cf3b2cb02f9b8938816ac0fced8313a1fed0289a1a79cd1"
    sha256 cellar: :any,                 catalina:       "319fc4a824505d1b0b1d17dc5c40ec9fda3b9bee7f294529733081e0df461706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52bc0a06bb3b7c7d7b35c5844f291306df956b026c5d28535f6ac0272cdc42f2"
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
