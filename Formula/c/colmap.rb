class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.2.tar.gz"
  sha256 "d220b54481b08212dcfe9e6deca6e998546a462a80140c3bd4ed9318d8c74482"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_tahoe:   "38f81311d660ea880ffb384cb96f373f3557bae7ea17d25e12916bfe2519cd02"
    sha256                               arm64_sequoia: "b0b26302bbea8709a18f9cae843ffa788f9deee092e3f036a2b3c37d08fda24b"
    sha256                               arm64_sonoma:  "c3ebe7207395cc753523c5aa62e0fa6d9b009c68fb545c4000b3b372bdf42174"
    sha256 cellar: :any,                 sonoma:        "8126defc49671b961939ae69ba740ed97c58d2d6460e3854a9ca332c39f58a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e94c9e88ad49631f0411695007d7ee9231cd77c490c3608f6a63543bdc5daf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c65ca41c703e97e868b2ca07af482e72a8fac5807be90576de58283408f31fe4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen" => :no_linkage
  depends_on "faiss"
  depends_on "flann"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "onnx"
  depends_on "onnxruntime"
  depends_on "openimageio"
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
      -DFETCH_ONNX=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    # Fix library install directory and rpath
    inreplace "CMakeLists.txt", "LIBRARY DESTINATION thirdparty/", "LIBRARY DESTINATION lib/"
    args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
