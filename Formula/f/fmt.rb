class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/10.1.0.tar.gz"
  sha256 "deb0a3ad2f5126658f2eefac7bf56a042488292de3d7a313526d667f3240ca0a"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "480890b91ba1449df13105e2600082e750a32f7d90d102831ec8d9b9ff59f144"
    sha256 cellar: :any,                 arm64_monterey: "328cee472133dd7349c0ec8f18681f30390b7ad365cc264b5fd50538b6d79f97"
    sha256 cellar: :any,                 arm64_big_sur:  "cf5c7d6cbf061d65cec664c2b34c7f361e923a1e6f572a5b5666f8595ac9e6ce"
    sha256 cellar: :any,                 ventura:        "af911fe577c33457117fbe469d93e31ee50293b8fdb7192ff02929f1d0813a48"
    sha256 cellar: :any,                 monterey:       "70dab378bb5dbf4c5bbcae4c58c6d8251f620809c115dd077f181cc60f4a7e6f"
    sha256 cellar: :any,                 big_sur:        "24fed23a9f089e110a80e5da98a19254185e49ab8c89178b674f1089f7247c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf7110c690e14a8dd85e362b5dd0dc64bb118345a520bfe17f0ba5e4b4142c0"
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
