class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.2.tar.gz"
  sha256 "0f5c7e3de6316a513635052c5f0a16a84e1cef26a7d233bf00c21348462b6d6f"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22eab3f6edb254c1d4e2ded48f795bad876f130f03d81edbc4679ec66136820c"
    sha256 cellar: :any,                 arm64_ventura:  "6d6cae37f9439f4bbaa534412c3ec957ed8da0c9a14febdc387eae7d8e9a96dd"
    sha256 cellar: :any,                 arm64_monterey: "773966ac744aada4490deba607795cbbf4a506af2a3fa4196045f613fffcbb55"
    sha256 cellar: :any,                 sonoma:         "3882169b190fd2f7eda3d39c4f1fd9800f2e610ee5e058a91e0613574eea85db"
    sha256 cellar: :any,                 ventura:        "f0a79ecbfd60fba3650eb41c2abe5d93a3dae2a1756102bcc0b524cab2dbd91c"
    sha256 cellar: :any,                 monterey:       "8c67247601b0b4d2824e0eaac979c7f22d1ac43ab3b1cb55d765775b1e90d27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548d76fa95dc4639132aef2f2637db129f6c0a94d8e15f57db34b8fe4c580345"
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
