class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/12.2.0/fmt-12.2.0.zip"
  sha256 "a2f4a8d51178f954e4c339007f77edd76ba0cb2e36f87a48e5a5403d9be5878f"
  license "MIT"
  compatibility_version 2
  head "https://github.com/fmtlib/fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a218679bf77ccb0c76b316556f71a0bc5d5a1980d8cd3d2ea197a5829a140d65"
    sha256 cellar: :any, arm64_sequoia: "301a1bbf99d3401d4e971d957eeab6c07d08fe304a690b269e04df5424fcc9d9"
    sha256 cellar: :any, arm64_sonoma:  "2e7c7c3093a62b44a4ba23a73463558b6073ee7a63e9162403701edab9403739"
    sha256 cellar: :any, sonoma:        "125d40bb96aec4f198a16252ec5358ba1c96243003e2f05d74826d867e012ddd"
    sha256 cellar: :any, arm64_linux:   "95ede71090e1b588dc9accf17d79730b8a99e82abce47bfd580fb2b7c6a32cd5"
    sha256 cellar: :any, x86_64_linux:  "9d7617cdafe71a36c5371511cdeffbe0d171c1eb93eea555a1e4028af440f5c2"
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
