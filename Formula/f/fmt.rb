class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/11.1.3/fmt-11.1.3.zip"
  sha256 "7df2fd3426b18d552840c071c977dc891efe274051d2e7c47e2c83c3918ba6df"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "176baae8cf6882363e48404f538b8181b5564c93897688350744c63b0a6852fb"
    sha256 cellar: :any,                 arm64_sonoma:  "2869ca6363bcfbf99d5b1906d5a043c2f5cd0b38cdef3310fbd07d98c18eb332"
    sha256 cellar: :any,                 arm64_ventura: "352c08d6e66b6ea062093fe7c20613cd6ab2ebeb02359bda0790937233345f56"
    sha256 cellar: :any,                 sonoma:        "1f4a3dccfa9769b8545be00c4178e45ec26db6d2eaa8e01656543abc13685def"
    sha256 cellar: :any,                 ventura:       "01c711a37b515fa3183ff3fcc1eb4bc5fc508f36928b0575842039ba883391ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e03be1e1707a4238df9d0513bf9d0f4c415ab5044c26891420b8d263ddad90"
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
