class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/5.0.0.tar.gz"
  sha256 "fc33d64d5aa2739ad2ca1b128628a7fc1b7dca1ad077314f09affc57d59cf88a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ccb91ade299906ad02d49eb4f57fb3f3da9378ffd9344c7afe9cd37a18dd77" => :high_sierra
    sha256 "1c7d0df7c374395d846eea1886de23efb62f285b9f35b5ba386e58ac5c6913c2" => :sierra
    sha256 "12741d3c493511989b5492783249dab5d6f9306d71315a456db5513969f3325c" => :el_capitan
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
