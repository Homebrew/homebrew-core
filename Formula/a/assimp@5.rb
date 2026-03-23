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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3b5aa965098a82cc09f46f5bd129b9028a104298fb546485489554376bc6a2e"
    sha256 cellar: :any,                 arm64_sequoia: "be0c878a7f9ffd255736ce7234aa372530b87fdf607cc82e7a2ff9a8e6abf812"
    sha256 cellar: :any,                 arm64_sonoma:  "ef66cf43c97023ca761eaf432f7ad1ae99faddc5bc18c9674e287ba832f890e9"
    sha256 cellar: :any,                 sonoma:        "fa0f212de3c4f8f760ea005f81a13b2ddca9695d0033a5dc64c4253275ba409a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27d037b74bbbd744295ed2479032ba5e0be1b3afe67d44c45bc1de570e126ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40879bbecd152b067b98d81b1842174091a0c738825689f95565803c165bc73"
  end

  keg_only :versioned_formula

  # https://github.com/assimp/assimp/blob/master/SECURITY.md
  deprecate! date: "2026-01-29", because: :unsupported
  disable! date: "2027-01-29", because: :unsupported

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
