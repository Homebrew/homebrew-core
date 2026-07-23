class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.1.1.tar.gz"
  sha256 "0cadd938756d7046055751ca35bcf0d35911403fcb65b91d022ddc418dc110a5"
  license "BSD-3-Clause"

  bottle do
    sha256               arm64_tahoe:   "514a7273908c205a09d7d936a98a4cb05c4c519e40c9f849b6983f8a7bed2291"
    sha256               arm64_sequoia: "6a180066637a35a927b9f2a4f8711d3a3658c762a1de31c9696e277ae3a9950a"
    sha256               arm64_sonoma:  "bf56e52607fdee8098dab53f0ac36d13156820041d3a6eb672a806c1d560a6f5"
    sha256 cellar: :any, sonoma:        "a4e19985a6afe0ae7bc3922bff2b51c22abd777ec91b6c981a37552cab4e2f8b"
    sha256 cellar: :any, arm64_linux:   "8e238107bdc8b8aa55262a0aa29ada93bfc9016d922f093febf68d44c6174176"
    sha256 cellar: :any, x86_64_linux:  "35d349457264354e54971b3285ebb9e262e940d7786fc669e2a2ab3a372a1122"
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
