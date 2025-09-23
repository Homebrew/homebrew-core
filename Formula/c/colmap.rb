class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.12.6.tar.gz"
  sha256 "f66d34be7a738fa753d1b71aec4fb7411d8c117beb58d1f2ba84ee2696c96410"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma: "a695a903669295bf7c7d0600fda4d8c17aa00ae4a452a0de58c9a76e99c037f7"
    sha256 cellar: :any, sonoma:       "f4d49e7926090e199c3e5a6e92d8825da1e124172dd157ed9bdb25cba74b1f7d"
    sha256               x86_64_linux: "b5bdae09804df82c4eb7dae50e41f167ff54909b369a67b2f533f99cad110e67"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "faiss"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "poselib"
  depends_on "qt"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
