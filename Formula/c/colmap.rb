class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.13.0.tar.gz"
  sha256 "98a8f8cf6358774be223239a9b034cc9d55bf66c43f54fc6ddea9128a1ee197a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bb0d7ab5ba3fe96e0b6e1c0c81ef9f2f5ed137db4820c1925d6841c1e3737af"
    sha256 cellar: :any,                 arm64_sequoia: "0f7fe9af2233e8bf143eeab4aef89ff69a2b234cc898c8f2e70c8387b72b59ec"
    sha256 cellar: :any,                 arm64_sonoma:  "080acb7ada884629974b56d60b3887ba694af02126c4559581eed3fbace229f5"
    sha256 cellar: :any,                 sonoma:        "539ee7c51dda5fc6a8b3156b6791ba26a7ffbeee53d1cef646b0788c4f995c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93275bad43506351576c3408ab36c20ef18ffc37f63e7c99958ae21c8f211c73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be708787b8b54ba370f8d99f23b000842dea7cc76b286f2be65e93ee6c3b85c3"
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
