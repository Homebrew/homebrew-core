class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "https://github.com/davisking/dlib/archive/refs/tags/v19.24.8.tar.gz"
  sha256 "819cfd28639fe80ca28039f591a15e01772b7ada479de4a002b95bcb8077ce80"
  license "BSL-1.0"
  head "https://github.com/davisking/dlib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e216992b453822949a4eb33609281347e6da267c5fbfbed27b31dc7f6894b598"
    sha256 cellar: :any,                 arm64_sonoma:  "ec44f8bd772b8f2ecef5edc35de034dbc22cb1d2e4f494dd4f0a200a4f51becb"
    sha256 cellar: :any,                 arm64_ventura: "f0901f40485da2a73754ee3e2badb330ed26c11956f30014c155f3a78be4f473"
    sha256 cellar: :any,                 sonoma:        "ce1d25c470eab70aeab6ce93ce72f1e208d680ed9aa66873ea5094c29ae70e04"
    sha256 cellar: :any,                 ventura:       "58b309a698357a39bfaa908f473f0f33df35aaad22b4120ab87f3b284abe34a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3083eaf4ca63b9f2359c0e9f0d7a9176c387e4e74924261282937ab8c41ea600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b223e31660981e25df9e9febb186ec33796f9fc7a9e78a7c2adc46f762e06e57"
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
    (testpath/"test.cpp").write <<~CPP
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(/INFO.*example: The answer is 42/, shell_output("./test"))
  end
end
