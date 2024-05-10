class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "a90f77b0269addb2f381b00c09ad47710f2aab6b1d904f5e9a29953c30104d3f"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e66353354dd74172ec395b7e61e356faf50a7bcaac1243ea42307fdc0fdf43de"
    sha256 cellar: :any,                 arm64_ventura:  "cc1d2c1a8acfe0aab52790495d515b156dadb8ee3dec88d0f792102ee3b91947"
    sha256 cellar: :any,                 arm64_monterey: "e517f57425874252017d2b16262d9b230101593f60e9406a06a850da7e0cb152"
    sha256 cellar: :any,                 sonoma:         "da3682914a57bf6ccda53c876be45127d961a28d0ed48cf261648397dfc3d330"
    sha256 cellar: :any,                 ventura:        "6f11be3a3b8cad5ef4b15b90423a0d52b113096379195cb3893de2dcfe234187"
    sha256 cellar: :any,                 monterey:       "f6e85bfcaaf917b6088cf24c980ae12b478d3b574198c548a9540c9d77e8fab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4ccccd8ca4bbb031c08eb4cca5661fcca8d96a769893557a221cd3424516328"
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
