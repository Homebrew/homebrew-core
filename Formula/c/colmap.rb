class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.1.0.tar.gz"
  sha256 "fc944df46ee9c213d4256cec30c085a6baa67256e7e6e0be63b13ea43ce9fcf7"
  license "BSD-3-Clause"

  bottle do
    sha256               arm64_tahoe:   "8e8422441113d2e647af03b1080e3fd792b5e1764368e2977c73e948be3b5cd8"
    sha256               arm64_sequoia: "f594e5e2cfccdc8f424395d95298b0062b0ba69fd8721815ede7674229af4966"
    sha256               arm64_sonoma:  "6c38e1fd9bbb83a44f868294b3a1632f91ccc3440a91503ecac329441d8ba9f6"
    sha256 cellar: :any, sonoma:        "9f6b4545d9688536ce00766357617e42fdddac7e45ae8fd8f4446acf69b02a96"
    sha256 cellar: :any, arm64_linux:   "d0c8c4a4f93298137983cf36e470934ace232da13c854d3856ceecd987f20521"
    sha256 cellar: :any, x86_64_linux:  "109588e3dddbc95036efd042c7c6572ab573cfe13908ccb4c1c32557ae566a07"
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
