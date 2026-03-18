class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.2.tar.gz"
  sha256 "d220b54481b08212dcfe9e6deca6e998546a462a80140c3bd4ed9318d8c74482"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_tahoe:   "2d6dd7a3b3ef65250569478223c1fe566bddee3b969f306e2bd4242b295932cf"
    sha256                               arm64_sequoia: "d4b3e047ecd328f53667dbf9aa90134cd86f695598f6815a21aacd03ccbe9775"
    sha256                               arm64_sonoma:  "7ff4e637e90642c4a3d1544329bf67d877aaea46e4d16f5b8ced66dbf766cd3f"
    sha256 cellar: :any,                 sonoma:        "08d899b6af6ba6a63c7d95067d89431d93389252040ef43a23d0556d8f9659fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75084c6ffc92fd0942636f7b8deaaa184e8b2a7b4737fa1aaa2a869d721c2f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "065d9abd82317c9daf9518fba206faec973d616d461f2f7d9bc92faa80ae3514"
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
