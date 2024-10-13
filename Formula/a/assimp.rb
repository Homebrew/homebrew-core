class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v5.4.3.tar.gz"
  sha256 "66dfbaee288f2bc43172440a55d0235dfc7bf885dda6435c038e8000e79582cb"
  # NOTE: BSD-2-Clause is omitted as contrib/Open3DGC/o3dgcArithmeticCodec.c is not used
  license all_of: [
    "BSD-3-Clause",
    "CC-PDDC",   # code/AssetLib/Assjson/cencode.* (code from libb64)
    "MIT",       # code/AssetLib/M3D/m3d.h, contrib/{openddlparser,pugixml,rapidjson}
    "BSL-1.0",   # contrib/{clipper,utf8cpp}
    "Unlicense", # contrib/zip
    "Zlib",      # contrib/unzip
  ]
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3617c461f17de42a22ab7090b1b056b16f854f767bcbd9f46e3df1d1c2374b0b"
    sha256 cellar: :any,                 arm64_sonoma:   "6e0aead723a0156775a0e547d7c38da9893f0db854e32932e168f09b9f33df1d"
    sha256 cellar: :any,                 arm64_ventura:  "7ced67d760a444e794361406950f9cf559448bb1820ed27f151c8026df25109e"
    sha256 cellar: :any,                 arm64_monterey: "e37e55230c1dadd42cc118a8cc7b1ede59226d833731c4da7c7edd2a7f7e89e8"
    sha256 cellar: :any,                 sonoma:         "97806c9287013e10f6cd45d131e2936639c714048393699d607189f302d4b457"
    sha256 cellar: :any,                 ventura:        "fdee9585eca259f83b827a0b7f7161599a914150cf3ded457e8d9c51eed5a6a7"
    sha256 cellar: :any,                 monterey:       "6b2af335f9c9c4a0706e9a111d45e33a1feaf78aaffa00d8c8361e0e2f5bd1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46b2c127678c024d31c2e873fb39739a65ce04718439d1e6661a8dc7aacdd4ec"
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
