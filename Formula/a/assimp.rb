class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v6.0.4.tar.gz"
  sha256 "afa5487efdd285661afa842c85187cd8c541edad92e8d4aa85be4fca7476eccc"
  # NOTE: BSD-2-Clause is omitted as contrib/Open3DGC/o3dgcArithmeticCodec.c is not used
  license all_of: [
    "BSD-3-Clause",
    "CC-PDDC",   # code/AssetLib/Assjson/cencode.* (code from libb64)
    "MIT",       # code/AssetLib/M3D/m3d.h, contrib/{openddlparser,pugixml,rapidjson}
    "BSL-1.0",   # contrib/{clipper,utf8cpp}
    "Unlicense", # contrib/zip
    "Zlib",      # contrib/unzip
  ]
  revision 1
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0930951bcd9774b987699ee7add5fda6ac3b00e2673acce808c184aa7b61760a"
    sha256 cellar: :any,                 arm64_sequoia: "a4e025c0806ce486f8a80f29181ac4f3d32f3d123e8a053da8be874ff99382a2"
    sha256 cellar: :any,                 arm64_sonoma:  "18d6b231e7f26e98a0487a3b99870cae734df4beda140ad9e64ab9bdd28f089f"
    sha256 cellar: :any,                 sonoma:        "def0ed8dc8400652de3695f530a6ac4c21c986cd0b111814d839f28ac7664f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c098bc898a711aff23c8c697e0689a1856f661d74b81c94f9ba50be348d0d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3524d1c82108896fb32b8ef1fc81cf252b4c59c0669dbf3c394c0a90c846dc34"
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
