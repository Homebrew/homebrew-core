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
    sha256 cellar: :any,                 arm64_sequoia: "a43d70a501a16ef7b9f278cea4a99798d080395e5ea50e452c2e0bd0fb07006a"
    sha256 cellar: :any,                 arm64_sonoma:  "ec2d87fa225a09cb108f9611ed10e6fc9f3b86413373f1babd9bd2be94318939"
    sha256 cellar: :any,                 arm64_ventura: "18cb56c4bd3dfdf3f2ede01a944edec69f92b90b97a50aa856fc69cceaef901b"
    sha256 cellar: :any,                 sonoma:        "8ba45ccc2774bc0e17f811f836406cb3d5fe129f4a3c087ac2250cc3ab064f69"
    sha256 cellar: :any,                 ventura:       "c1fc0889307ab26168df04ed10c1133055aaf123034350dbc2bdb3c7f475d078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d5254106aabf9cc5097670753afc657b9d93c3003bef4d46225038561c10e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a995c5ba9d96c7ff5f1a34bc184bc213f404a1a4e9de7769cc5b4c60f120a29"
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
