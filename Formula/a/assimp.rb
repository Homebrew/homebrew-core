class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v6.0.5.tar.gz"
  sha256 "edf3749559c2b7d1f758ffb66fc5bec62186221e623b7f2e8969f17ee46ecb6f"
  # NOTE: BSD-2-Clause is omitted as contrib/Open3DGC/o3dgcArithmeticCodec.c is not used
  license all_of: [
    "BSD-3-Clause",
    "CC-PDDC",   # code/AssetLib/Assjson/cencode.* (code from libb64)
    "MIT",       # code/AssetLib/M3D/m3d.h, contrib/{openddlparser,pugixml,rapidjson}
    "BSL-1.0",   # contrib/{clipper,utf8cpp}
    "Unlicense", # contrib/zip
    "Zlib",      # contrib/unzip
  ]
  compatibility_version 1
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d2cea4c896625a1772b252a6ef47a6f92170d5cd6d627d4fa02baea0803cb22"
    sha256 cellar: :any,                 arm64_sequoia: "7ff7d04b3a67e6992992030de224a2edb46ee0f8b71045b8c80d3f11f58a0438"
    sha256 cellar: :any,                 arm64_sonoma:  "1155bc594827e2d1c810a0c2d67b78beca8aba61a0f037e317f49243060e4465"
    sha256 cellar: :any,                 sonoma:        "7a60edb6511ace111a3275f7edf765f7c8bfa1f91d0ff86066ccb308d496f4de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd7a50450be8428d982ea7cb68d993a9e7d6ea73e1b39850ebf2bdb8d2ace56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6199347daa14e928216dfade64f4dea018ce360d818bcc37aafb30b805bc46a0"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ignore error on older GCC
    if ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 15
      ENV.append_to_cflags "-Wno-maybe-uninitialized"
    end

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
