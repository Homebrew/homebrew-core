class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.4.tar.gz"
  sha256 "d881911d68972d11563bb9db692b8fcea0ac1b3fd2e3f03fa0b94fde6c739e43"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "349de1e0fd1a13a138faae3a4df8ad3fc383b859bc9cdf9f9692c20b768a8862"
    sha256 cellar: :any,                 arm64_ventura:  "e00034573b2c57f8f7c517a3605bc6465c9c75999e5780e06c5a1b47ff2ed6bf"
    sha256 cellar: :any,                 arm64_monterey: "64418c886f8b3bba884d906ae37763069e2fb69d5cdc36ff6074054dba15db6d"
    sha256 cellar: :any,                 sonoma:         "2aaccb56920511cb87630695ce43a782876f9f84395919595d423d2348ab1868"
    sha256 cellar: :any,                 ventura:        "d24b6b3902e7b30db69656f87a11f3ec0d270b77281591ad70e433d2e21d8d27"
    sha256 cellar: :any,                 monterey:       "5e7d9540338554f8f4485ae8f322e18734cb1bb6102e595d61eed85a087ceaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b89725bd805895a735b2a4ec83180ac17f14d6511716f820ec3db21d0265739"
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
