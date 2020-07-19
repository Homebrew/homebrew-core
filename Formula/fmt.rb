class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/7.0.1.tar.gz"
  sha256 "ac335a4ca6beaebec4ddb2bc35b9ae960b576f3b64a410ff2c379780f0cd4948"
  license "MIT"

  bottle do
    cellar :any
    sha256 "c214a12c77f38844d841457492cc4f36313579b62fa19b6649fe6b4c50171bb7" => :catalina
    sha256 "466655f03e704f70d47078f2f7b59239cfe35c718222a94e0ea0c7354382e78d" => :mojave
    sha256 "41c2cbcd32a6c4ee8dc95d904319870f228f0a34dfd34388b9d2a2149b477118" => :high_sierra
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
