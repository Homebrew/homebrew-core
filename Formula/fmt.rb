class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.2.1.tar.gz"
  sha256 "5edf8b0f32135ad5fafb3064de26d063571e95e8ae46829c2f4f4b52696bbff0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bfd52080d4403b30f1d2b575f2c8d8e4e1e7f02d81e5f8b79a9c6c396e0ab40" => :catalina
    sha256 "5d5f048abc908691c57c5fe44ed324d3f4a1f072f75f3c8cc1a9d9566209e620" => :mojave
    sha256 "2d1bbe04b4103c1594d2deb47fbe9ef5b775fd962103a254eeed3c9ddcb1c103" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
