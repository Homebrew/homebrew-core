class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.11.1.tar.gz"
  sha256 "d2c20729ab5b1198e17725b720128f304f4cfae5c0a8c20d75c0e9c5bdee5860"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "23417490a270ef9546bf76e6f87e8bb73aafab7214b8677f22c0266a1178e914"
    sha256 cellar: :any,                 arm64_sonoma:  "fecc9295c3bc78930dcddaf60da846a22776b3898b3bf71f0bf5306e140c412d"
    sha256 cellar: :any,                 arm64_ventura: "753cb168ae9b6273a59af17417e76b640f5b83a7c63ec6b0c44115e7917f25b3"
    sha256 cellar: :any,                 sonoma:        "1fcb269f274f8283d9d88139a317cca37fd3a9a3b052e08fadbfe5d179f60141"
    sha256 cellar: :any,                 ventura:       "8e4b55f3556981af9b37da86be510eaae74f9963ea1ee67659f73a668db15e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "047a91d11f90d80e0a48a151db101c00838b18030006fcfe19ba694d8d4bb141"
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
