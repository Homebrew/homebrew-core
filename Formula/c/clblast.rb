class Clblast < Formula
  desc "Tuned OpenCL BLAS library"
  homepage "https://github.com/CNugteren/CLBlast"
  url "https://github.com/CNugteren/CLBlast/archive/refs/tags/1.6.3.tar.gz"
  sha256 "c05668c7461e8440fce48c9f7a8966a6f9e0923421acd7c0357ece9b1d83f20e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cfd48f3ebe4c5fd8a8154ffea4e8064d76a3f7629a07afafffcbfb34df4d6b5b"
    sha256 cellar: :any,                 arm64_sequoia:  "62eea554bf1f9118b780962ec97537478020d4a4850942d200fd100319ebc25a"
    sha256 cellar: :any,                 arm64_sonoma:   "51694bd4a8eefd817e62561ef30afa0807dd169cf8b8b3ed3599afd8240f0772"
    sha256 cellar: :any,                 arm64_ventura:  "4ae97edde32865dae186f21292d0885d402be3e4622b76fb77f5b6240035f560"
    sha256 cellar: :any,                 arm64_monterey: "b2190d5fe22baa139b0c6d4884af910db597fdcf1f6b02cc8dcbd377991f1e4b"
    sha256 cellar: :any,                 sonoma:         "7af136b15b5d8fc47a2c392052a7b35ec447c4530c3f57fab3675e45e55d1e96"
    sha256 cellar: :any,                 ventura:        "05968756c5c41c794e4134f1dc93756efe8beca0f76cd6959a7ba839f75ae791"
    sha256 cellar: :any,                 monterey:       "3fbca33d20a9d99bc166e1af71058bfb56ed064ea5fbfdc733e1373afc553587"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "07ccdb7ac4ae569a10b3373edeb168b25505896269b7921f7f624094acf9b27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc7ca301aa5cfd50033c67343f4fddcedffc6536274423081e71a2f86282e8e"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    # Backport support for CMake 4, remove in next release
    inreplace "CMakeLists.txt", "cmake_minimum_required(VERSION 2.8.11)", "cmake_minimum_required(VERSION 3.10)"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "samples" # for a simple library linking test
  end

  test do
    opencl_library = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"samples/sgemm.c", "-I#{include}", "-L#{lib}",
                   "-lclblast", *opencl_library
  end
end
