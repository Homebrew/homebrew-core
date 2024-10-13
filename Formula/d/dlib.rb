class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.6.tar.gz"
  sha256 "22513c353ec9c153300c394050c96ca9d088e02966ac0f639e989e50318c82d6"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "81ea4ab8b5ebdc18921b8b4dac89c043a16d3eb49055c6d8e98cb8cdccca5041"
    sha256 cellar: :any,                 arm64_sonoma:   "d19cac41cc5094b91fe62eda9bb6aec0b1c07d44ab9a13f85615f05d864b8df5"
    sha256 cellar: :any,                 arm64_ventura:  "19cd0cbae5086be45a52545ba0c902349a48bec3584b096544af783febf28fcd"
    sha256 cellar: :any,                 arm64_monterey: "d36c2a0183d5ac011c6e1f4d2e001ec2cabebef683665d067b79eb3bddeabdc2"
    sha256 cellar: :any,                 sonoma:         "57cf219d4134fe9c33e0742e10ba85b75d1cc9bc56c4b8e184658899ba726db3"
    sha256 cellar: :any,                 ventura:        "0ef2313efb429a44df22d991a675b1ea8e160228df93236c84777c915b6b26ab"
    sha256 cellar: :any,                 monterey:       "c0cf0849334b7dac93a78c7614072fc780263fb58765deb87e036ee399d2d043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a170e4b2d2b3623710824c31c0673c82d75ace2b8f1a542532a31fc6b746f1"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_lib/shared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if OS.mac? && MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    EOS
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
