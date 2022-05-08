class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.24.tar.bz2"
  sha256 "28fdd1490c4d0bb73bd65dad64782dd55c23ea00647f5654d2227b7d30b784c4"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?dlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "716804b2263be0d5838f771743a0c2c3bf2edb5d90b9c45daa71a9aab5fbf52f"
    sha256 cellar: :any,                 arm64_big_sur:  "f076d570b9b83d388a153ca175780a39a1aded6270955bc2d983184240ee107a"
    sha256 cellar: :any,                 monterey:       "a507111d2b5820fa2ae50266df3e3063ac0a52e16ec2aaf6cfb015fbd111e615"
    sha256 cellar: :any,                 big_sur:        "dbca75d3d14e4c314ebb9d3f273684140dd999929019a950b111d6fbcc012439"
    sha256 cellar: :any,                 catalina:       "54272687cbb34d28d0b61e93183d8cc1257db518357ed7fdf3fdb997c0666395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b2a7242c594ca4f6da385e61701705f1b309f96bcc007aa942491dcd1e7ae82"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas"

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DDLIB_NO_GUI_SUPPORT=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if MacOS.version.requires_sse4?
    end

    mkdir "dlib/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
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
    system ENV.cxx, "-pthread", "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
