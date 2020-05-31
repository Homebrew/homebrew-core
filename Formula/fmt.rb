class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.2.1.tar.gz"
  sha256 "5edf8b0f32135ad5fafb3064de26d063571e95e8ae46829c2f4f4b52696bbff0"
  revision 2

  bottle do
    cellar :any
    sha256 "9de1ed4c9ead235d231dd0e893e587213795aea11793bce19193fcae519c9b4c" => :catalina
    sha256 "6150b22430f009a6e04368f4c182a9830f6d1f802e942421f4b107c6403d474d" => :mojave
    sha256 "3410c7b3f411cf56e329c7d303c5ff238f723879402d0f870b94475221934e4f" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
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
