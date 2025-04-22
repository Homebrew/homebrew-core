class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/11.1.4/fmt-11.1.4.zip"
  sha256 "49b039601196e1a765e81c5c9a05a61ed3d33f23b3961323d7322e4fe213d3e6"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a66ba523ff4d827b679de7e9ed284a1f3fc091c06152c64946e4c536f284d8c0"
    sha256 cellar: :any,                 arm64_sonoma:  "bd4ba9753212bb107c8e0a5dcc4f78afa076537a718987d9f302f09c447ce275"
    sha256 cellar: :any,                 arm64_ventura: "dd8071bddd6d4c1b2d21e5cd4caa4d78cdcf7218caedf65c58ef8e58071bac12"
    sha256 cellar: :any,                 sonoma:        "4c472ff65bc9d0f5d5bc0631dcd97c2ed17d3d5dc8f4b3deae3d6b87cb62de56"
    sha256 cellar: :any,                 ventura:       "4fc070f491d3b1396aac67c75c882b73457a3b40877f5bf53d1b72e4e74d6cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b65b9f67358eb90827d888f0ede3eba6c1bc0a5da34fe4187d067852a65fe5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd54b7682a79a203e780740e07aa1658998392f7b5787dd3cf8c7d17da2680b"
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
