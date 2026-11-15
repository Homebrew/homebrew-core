class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "https://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v20.1.tar.gz"
  sha256 "fbbc5f5819c598c54cc682b78813226467f36c0c0ffa19ad527412d87970fdb8"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b6f6b2ed845eda910d5b67434ea9909cb70a5cc08fd5f1e70f04fe2e0e48b27e"
    sha256 cellar: :any, arm64_tahoe:       "c06e88b703bd85b9c2909ce4c683972ea65eb5361f2f00c96bc2f7a5b13bc687"
    sha256 cellar: :any, arm64_sequoia:     "e429fc1cbf6dcc70f37abb4d99b42e53f40724880d4145a29e6bdbd296087534"
    sha256 cellar: :any, arm64_linux:       "cf54d2a5a4d922981183c0f803e3ae6ee195835a9a5d720dbb559a25c8ca7ab6"
    sha256 cellar: :any, x86_64_linux:      "f910d266fe85af8dbbad6a504075db4cdeab6e3c8ee52723f6c5d8af88d28065"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  deny_network_access!

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{formula_opt_lib("openblas")/shared_library("libopenblas")}
      -Dlapack_lib=#{formula_opt_lib("openblas")/shared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << "-DUSE_SSE2_INSTRUCTIONS=ON" if Hardware::CPU.intel?

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++17", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
