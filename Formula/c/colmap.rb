class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.1.1.tar.gz"
  sha256 "0cadd938756d7046055751ca35bcf0d35911403fcb65b91d022ddc418dc110a5"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256               arm64_tahoe:   "e1751ac1e2ef1a407d0e6a2b455b93c2e5d6514aab241b6df162bd1deb1358b1"
    sha256               arm64_sequoia: "63710bf2c48708309e9147b4cd669408ffd0c94064f14621693b9852b31293c5"
    sha256               arm64_sonoma:  "9c29d290792ce7dd4e322014e3fb9beac5952dea893f7583956b0c078bd96982"
    sha256 cellar: :any, sonoma:        "4b9ea15305d0ad94aa8441fefa3212d8da00969573d28cc5f43058cb12a027de"
    sha256 cellar: :any, arm64_linux:   "edf0463a635bd42b4c79371addbd7acf8fcde62b87caaac0295e8c45b0d6c8f2"
    sha256 cellar: :any, x86_64_linux:  "08d9dd4c6812b86caa36e74de8f06cc2d62be9374fa516a86ea8679864f06de8"
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
  depends_on "mpfr"
  depends_on "onnx"
  depends_on "onnxruntime"
  depends_on "openimageio"
  depends_on "openssl@3"
  depends_on "poselib"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "suite-sparse"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
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
    # Set openssl@3 to avoid indirect linkage with openssl@4
    # TODO: switch to openssl@4
    args << "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
