class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.4.tar.gz"
  sha256 "200309abca2a3ee05970b1f8a48d545fc71f435dffe6764a8040f9f6f364da32"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "bd20d958cb4f60a42fd8b0ee259f8f640b6c158e16c62c531d5cb4b91b8c4ee2"
    sha256                               arm64_sequoia: "0bfe3baa1f9b1ebf142e88b4a175d31b0519412035f6c1ba7c58671a7795e631"
    sha256                               arm64_sonoma:  "7b5fe40717d09b3f18ecb90d128a5a8435eefbdf626f22e07ba36fe7ee911c11"
    sha256 cellar: :any,                 sonoma:        "05300b4770eded1de9d1ecbea8fccfd0ebaee1f2f011560e6da6424703bff77f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84cc786e811f4c7b34c7f7d2bd982a40e085cc3bbc7f963c82d9fd7a86149c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb6793d6681d0c1570c3cf916166c70dabc8eb58b69047cf1c1b8635d473a98"
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
