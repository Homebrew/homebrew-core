class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.1.2.tar.gz"
  sha256 "1cafc80701b746085dddf41bd9193e6d35089e1c6ec1940e037fcb9c98f62365"

  bottle do
    cellar :any_skip_relocation
    sha256 "de42f47758a6b09ca2b21292d46a8ecdafd437b05db6a06d4d926be5a86d3fa6" => :catalina
    sha256 "97535b05921e02922866ff8030c170955647bb0c1354df3c8b6c37562ebd6055" => :mojave
    sha256 "9e90b5c0df3f5858c1fa23c8e0e94562c2ff00cc3c37a0acb3a36a8d036c5a98" => :high_sierra
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
