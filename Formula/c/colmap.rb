class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.4.tar.gz"
  sha256 "200309abca2a3ee05970b1f8a48d545fc71f435dffe6764a8040f9f6f364da32"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256               arm64_tahoe:   "ce1c248c6e6d7cb6d1eeba1938826d8bbcc1ab2ee712fe623d76a610f2e809b3"
    sha256               arm64_sequoia: "c0452890cb7ffae3d50c67095365331b5835fab089f9535dc6c679a4a4d52d7b"
    sha256               arm64_sonoma:  "8a62c1a1cf708053b9e7c54f39465b051d0f24e632654b3d2034b6d9ebc03e7a"
    sha256 cellar: :any, sonoma:        "b259d8ea7322ddb2576f7debd5f18c45b405b186d5fc6ceb6e4ca3624a45213a"
    sha256 cellar: :any, arm64_linux:   "752e73f48eb481fcc19107676f1ed620a1d032244144bd895d95d4dee33b4580"
    sha256 cellar: :any, x86_64_linux:  "b6e707df8896cec1f06dba9a9cbe197428ad76ec61549e36b56fa959eb9a1691"
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
