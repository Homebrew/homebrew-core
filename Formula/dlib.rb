class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.22.tar.bz2"
  sha256 "20b8aad5d65594a34e22f59abbf0bf89450cb4a2a6a8c3b9eb49c8308f51d572"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git"

  livecheck do
    url :homepage
    regex(/href=.*?dlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "db4b583ba9e3005a3c2d36fdc5ba78e2cb3ccdebd85216c8e7a00ccbdd81106e"
    sha256 cellar: :any,                 monterey:      "62ee86d108c6feeaa5a75f8b28258b038d3b3f16d1c2d29438bcfeed33442ac4"
    sha256 cellar: :any,                 big_sur:       "5d20cfc1befae91082d391364cb07dfc68d99713694ac81539d027e2138cc5bc"
    sha256 cellar: :any,                 catalina:      "158a5e823cfda7ed8ef3ea9439d28b7c6508bb108f28fe8c94639bd35a9620e2"
    sha256 cellar: :any,                 mojave:        "40748e73bb88c567e6ca5b991f8e4282e46422e625ec2dcc0ff0f11a5ed76f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f62972f4cf86bda1cca8d5163dfa544e7f96f0084ecd72333d51245685f207"
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
