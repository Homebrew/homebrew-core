class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.3.tar.gz"
  sha256 "9d0a0916c5419d8e8c59839a729b041856d46f8abc911f32847e3857918969bd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "efe49f613aba9613d3668da831972c6a1182b59e149a61118f4f4e3bc0384a86"
    sha256                               arm64_sequoia: "b99e92618b3a2cbe6db83e3df6189abeca0c0e707728f62531341bbfebb00505"
    sha256                               arm64_sonoma:  "a10ac9fa039653f3e6161e182bbb71657175f66605b68c32b89cb88259d6cd43"
    sha256 cellar: :any,                 sonoma:        "4c6e5c93b3b62b7364e3dc853582eb88cba26e275d8576bbe75c6853dcd3358c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c0fd27334eebd51b6a96d7c84f2e1eec9f8d9296053af0a5ccecb6aafb7993e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a541e640a3d699b1d8149dced386be1c3d08a73ac638531dfe6d584faf18deac"
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
