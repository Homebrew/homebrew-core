class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/7.0.1.tar.gz"
  sha256 "ac335a4ca6beaebec4ddb2bc35b9ae960b576f3b64a410ff2c379780f0cd4948"

  bottle do
    cellar :any
    sha256 "ab53db378762d5a7744f96ffb3e6fc9d44703b4423298cfeebcdc26cc288f5f9" => :catalina
    sha256 "8874900fa95b68d911ee47ce094f8912f553a1dd44f9c4859f0aeddd15ece3c8" => :mojave
    sha256 "2e3f82778b491b5178d21d0f22addc28fdccc59e140fe319ea7d7da73134f728" => :high_sierra
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
