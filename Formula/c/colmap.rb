class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.11.1.tar.gz"
  sha256 "d2c20729ab5b1198e17725b720128f304f4cfae5c0a8c20d75c0e9c5bdee5860"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a10d84ff5e6e26782f2043ea71657f741f6ad2a84870b15126d52dd75216fab8"
    sha256 cellar: :any, arm64_sonoma:  "a3b2341aad18e5ee0e65a9ca38d497de5f2dae573525588e01026e609ff5929d"
    sha256 cellar: :any, arm64_ventura: "7d88ee8e8f5fc8b369050c706df0a6c6179eeb7a56262fc17d8e5ea0f9e3d050"
    sha256 cellar: :any, sonoma:        "9b56b2f3bdae3e126dff816fd6005b1142a7af895166666e626af58c93ef2497"
    sha256 cellar: :any, ventura:       "40a9ed14c6bdbb969209c24500ab814e0614740492e8cc26d0e50b2355f26fb5"
    sha256               x86_64_linux:  "ce9da6e8e8f4c41ef007ead45ed70122eeb4739f82bdeb36bfffcbfea922b5b9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "poselib"
  depends_on "qt@5"
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
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
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
