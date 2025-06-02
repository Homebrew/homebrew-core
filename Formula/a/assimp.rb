class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "95a7263db4a8478bf0ffa22cedd249f5ef02d7dcafd14d288bbc9a5ca24e5c1d"
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
    sha256 cellar: :any,                 arm64_sequoia: "ccf4f9fbfb87e220d791b8bae7a03840e6d52440f4788ede9ce189a9157049bd"
    sha256 cellar: :any,                 arm64_sonoma:  "c113d9fc5739e25495ef086f9356a8ea2676757a7d84326c285c425e4ddb1f02"
    sha256 cellar: :any,                 arm64_ventura: "cd67606d49b2ac59e3d223c4d1a4ebace5a1c60a853d5ece4486a88654c0e1d8"
    sha256 cellar: :any,                 sonoma:        "408b6e7c895e18d2cfed9337f6c323e092ae09f3b8d32e09d6ad562bb180fc46"
    sha256 cellar: :any,                 ventura:       "bbabbc09843ea4a0e2ab4b95f310c211aba7e78b665dd974ee65495036562074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ea2edbe7367cae0d51accda43f797269828c2049ee2b48e5c504606a0fed5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d9455ac367dc04ab56783795b31269ed338668643b5f35ddb8bc2815bc7c4e"
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
