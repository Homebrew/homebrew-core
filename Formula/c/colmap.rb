class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.3.tar.gz"
  sha256 "9d0a0916c5419d8e8c59839a729b041856d46f8abc911f32847e3857918969bd"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_tahoe:   "2c6162883f5a8420a0510bfd143f3e78948b6b21401bad656c0d7aafa46cc9a1"
    sha256                               arm64_sequoia: "e2f342414e5c63c625a7ffc47506bb04e7f5deac970797499858706a96ff3506"
    sha256                               arm64_sonoma:  "34fba5ca0ec55c27b3f0e7dffe4d7676d461d67a58463b607f5dcb4c0bc5ed0c"
    sha256 cellar: :any,                 sonoma:        "d99650f406f0cb0241428a4066f83f97a07179a52354e76b90e336131bb91bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4cff225e8bd2de10d4d9796fb0ed2bf18683dc96d75abfa0528ecf1cb108814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d788e296603f158c90ebfba060a2beb2543f4ee69347e18e9a924914f1769ba"
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
