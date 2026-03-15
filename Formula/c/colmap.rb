class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.0.tar.gz"
  sha256 "4d5328ffaea31683e27267b7eb13c89f7dfafe7142277c8cdf8d5bb97f00e579"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3ddfd4601a31a3585f41cbcb156478a33504ef9e26f4bcf28e4b94edfc2fdb0"
    sha256 cellar: :any,                 arm64_sequoia: "95161d695470dcd967e382792a7af70502e9a92611d33123a3959ab1f1c36697"
    sha256 cellar: :any,                 arm64_sonoma:  "a8e46cb6f6a1829d7adcf283522843635172e2208253850cb32710e9ea79ec3b"
    sha256 cellar: :any,                 sonoma:        "32915062b90b298a0e178910753d28e533f6cd8a1598db75b14bf0921ec705b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144a551ecdef01a2b23157e9007b3770b243cd65b25d3705d6c914c77310f033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "633c1c82e404ff2c340d3f28d0a25d781190631ba060f0e2b2db36582aa85662"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
