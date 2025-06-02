class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/11.2.0/fmt-11.2.0.zip"
  sha256 "203eb4e8aa0d746c62d8f903df58e0419e3751591bb53ff971096eaa0ebd4ec3"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2993c31d6b043978465fb9c81571acb7742b064e7da1757d894cde11d380d106"
    sha256 cellar: :any,                 arm64_sonoma:  "21f1e3cd8c9b24293c9a00fd01743f0be9dd6405c31a834cf6599824ace92c39"
    sha256 cellar: :any,                 arm64_ventura: "5d9b219e1a18aff1c6a6a6444ae8816f5263cb131f56a78a2e8083bb52b8fe7b"
    sha256 cellar: :any,                 sonoma:        "87df188fccf61d985adb0d23be2a5793015485d180a2e196539a771223a72870"
    sha256 cellar: :any,                 ventura:       "b54359c024bb64eef1b2391dbcb532aec537470503c3b2a525f323affd624c09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d258b4d9a84b8fb2cec4ec9b71cc3db2ac05876fb454a2e253875440ed3db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57840d386149a78306c8ab69226dc636768456c5cb6b3452c081b0279a8f0db3"
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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
