class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.13.0.tar.gz"
  sha256 "98a8f8cf6358774be223239a9b034cc9d55bf66c43f54fc6ddea9128a1ee197a"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4191a5203b7c9413d9d4c871a41ccfdc3f7f6209f358748ababfe839847a8ff"
    sha256 cellar: :any,                 arm64_sequoia: "4917ae56796036fc9d4ba0474eaf5fd5b5ce22b7f8f67b6bfd2b2a9e72d5d5dc"
    sha256 cellar: :any,                 arm64_sonoma:  "e27256e1094b70e9e90544747d51a382e8b49f93973ba589bc3928250c1e1b6f"
    sha256 cellar: :any,                 sonoma:        "8781de1620230e34388e9e9c146237df8e2ee4648de5abb62a7377246f900332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0257d371af643c5b1322fbbdcb676524b0c08b838d341be4eb7cd45b59598d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e46bb9bb4291c3e21b985b5ff605f36fabb29d7ddc20991bc8c7cfc30528c0d"
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
  depends_on "openssl@3"
  depends_on "poselib"
  depends_on "qtbase"
  depends_on "suite-sparse"

  uses_from_macos "curl"
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
