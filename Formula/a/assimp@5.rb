class AssimpAT5 < Formula
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

  livecheck do
    url :stable
    regex(/^v?(5(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3faef1c367567a99e18a728139d787d046e0aefc30f65d541f88ccfd27b1ce19"
    sha256 cellar: :any,                 arm64_sequoia: "88b53d2e04bf2557a8b9231ccf1d7924bb55917003fe16872c8f864de930feb4"
    sha256 cellar: :any,                 arm64_sonoma:  "74157cf837ac90bb9378ba79f75d9cbf8f4a3db379da1dc5f03db3748e2e8a42"
    sha256 cellar: :any,                 arm64_ventura: "1b1d4f11a3c83bb8a7565c877397c86d4a06c952d3b4b85d8a756ce25516059e"
    sha256 cellar: :any,                 sonoma:        "72f6ba4406def81da38c77507f259cd9a1f28b8efb14983ce7780007cd951391"
    sha256 cellar: :any,                 ventura:       "17173cbe629f6dc15c3aecd382391aadeb74abd6c374760ad6143a5c16410138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dddf2d65a2c8f08efb3a198cd825952be67dd8785da42725dd50cda9eead96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74fb37f50e5dea840d202a0b0cc5c8b5e7589128e5a294e23209ca131277ad43"
  end

  keg_only :versioned_formula

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
    system ENV.cc, "-std=c++11", "test.cpp",
                   "-I#{include}", "-L#{lib}", "-lassimp", "-o", "test"
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
