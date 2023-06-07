class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/10.0.0.tar.gz"
  sha256 "ede1b6b42188163a3f2e0f25ad5c0637eca564bd8df74d02e31a311dd6b37ad8"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9afa87a18e3d433f93e2f73f745cbe2cf9a8c3727bb56e33d5f8520c4bf676df"
    sha256 cellar: :any,                 arm64_monterey: "7707eadbcbeffaa4a8792a7bc32f8d55e2c534058f6f7d57df4dba8dceb0aa0f"
    sha256 cellar: :any,                 arm64_big_sur:  "2c7442e8778aa6fcb2e5c9ca949929a15da54335f77de90ab6091456975be0a1"
    sha256 cellar: :any,                 ventura:        "917617f5a1a915c7930f0ccddae8732223fa5e7a624389d2827dd323fc1ce336"
    sha256 cellar: :any,                 monterey:       "b35edb2d90f70ae1cae402762ba28a9d07fb943cedcdf8f213945acf202b8c8a"
    sha256 cellar: :any,                 big_sur:        "5417b3060fe63a4a5d9da427f30fcf5194160e8fa3e9f97e4743c80212d9d90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6477b43807b7741da0540a92098e07850b73f556adbc79504ef007ebec22798"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
