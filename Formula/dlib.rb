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
    sha256 cellar: :any,                 arm64_monterey: "ce4fe45d2e501625e5e8a4b7b274151c7ecacfc5ba081d7ac660b4e231a1a66f"
    sha256 cellar: :any,                 arm64_big_sur:  "c2c4070c3d21aa827d2261564aec34317ac13317faf5ce23370b04a779e40fce"
    sha256 cellar: :any,                 monterey:       "41275bb8f75b188f3da28618944fffc36d85420b86ad485f24b98a4a51c52b5c"
    sha256 cellar: :any,                 big_sur:        "5306628da782489ff1cd32d0e0b4ae3b9e4bc467bdd525386772f306c4042b29"
    sha256 cellar: :any,                 catalina:       "de3a205e585a92c5ba3b983dcdbaf7baeced3b3408efa3919d538f0531bd19f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d1b7577ff56a2cce011dd0759b5dfd4865f3222c57950a4e154f582c8765d0"
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
