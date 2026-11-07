class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/12.2.1/fmt-12.2.1.zip"
  sha256 "870a49acec5bcdab236aeea834ebd7f0b8548a7d8cea33c996b6873a37f2d50c"
  license "MIT"
  compatibility_version 2
  head "https://github.com/fmtlib/fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8401e362ca031b083150a1853a6dfd4c65573b3d2acef6c188528492d5a8f6a8"
    sha256 cellar: :any, arm64_tahoe:       "25bdf7d81b112069ba5729c5f8901a6233cd2b6672ff1bbe7a9ca3a63ed2f90e"
    sha256 cellar: :any, arm64_sequoia:     "8a8c73c17025670d13e28efe475ddaf4c9aa6cebb9104fdc18b28f96693df82c"
    sha256 cellar: :any, arm64_linux:       "eddf6744630de1406e88200bde0e326f38292bb8919e455673294e794786c27a"
    sha256 cellar: :any, x86_64_linux:      "b9b63eab0ea3bb8aec944e69ae336b55b7fd86d26dc469e137fa67dcd874398d"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
