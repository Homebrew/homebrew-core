class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "d1822d9a19c9205d6e8bc533bf897174ddb360ce504680f294170cc1d6319751"
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
    sha256 cellar: :any,                 arm64_tahoe:   "cd42d21879d88bf5c153f8c356ba0641b3cdfa8d1ae0d965734ff51440c9304d"
    sha256 cellar: :any,                 arm64_sequoia: "6ab85fd16cd1f86fc8ee199e49d4f57d9b23eb0e2b598e32d1450913862506a8"
    sha256 cellar: :any,                 arm64_sonoma:  "3ce55f76aaeb9b538266dfc81622bf6e33e1d4fdf2aebf69e442369378830a95"
    sha256 cellar: :any,                 arm64_ventura: "ed951286fbf3dc3362927d2698df086e7da7ed6ae9be2fd83f4fba310431266b"
    sha256 cellar: :any,                 sonoma:        "1b6514222b86287994281fd61e7d30e5a087ecf143fc3f190afb9fc17048f061"
    sha256 cellar: :any,                 ventura:       "69f5e3ac41175e81f7431ea19ca6514790ce82107f71a843f739042394d221f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c781ef6fdfe87c1074960fd21abfa8e43c6ff35955b15b29a1e0ef0ceaf08f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e96dbe0de6b786a99551d144173516e4ae104bacb2c20ee0bcabd6af405ef90"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

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
    (testpath/"test.cpp").write <<~CPP
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    CPP
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
