class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.4.tar.gz"
  sha256 "200309abca2a3ee05970b1f8a48d545fc71f435dffe6764a8040f9f6f364da32"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256                               arm64_tahoe:   "b215232218f0be33c947ec5f8fe35b4078a6f3bf572f7a1e5c2260a7718ab240"
    sha256                               arm64_sequoia: "eb9b44af4aa8f6730b5686f7ddaf632764348af9dcf8485c734ec39fefcb9abb"
    sha256                               arm64_sonoma:  "812dc0fa9d00cf75de0a0afa3321d465a07abf80f2118c63a97051d96f42d475"
    sha256 cellar: :any,                 sonoma:        "e84c5d5786d411f923984b7968c2aa6bcda7ad96717467ec092a4725824b1200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0210e5e15f2be8369450657edcd7182fd9c754a2b4925b13c6261abca76a396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5a3be10cc644b96f3c437329cbde3a3482c8f4582e2188f1e49557550c43c8"
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
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
