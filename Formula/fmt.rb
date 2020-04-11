class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.2.0.tar.gz"
  sha256 "fe6e4ff397e01c379fc4532519339c93da47404b9f6674184a458a9967a76575"

  bottle do
    cellar :any_skip_relocation
    sha256 "c662401af7110ab38816f4db9dcae837f92b01ee9138ef3377ac57b211598454" => :catalina
    sha256 "dd5ec21df7765d08e72d830627887970af1d37738784c27fbb8f4aacc1ff5987" => :mojave
    sha256 "3c66d511edd661db1e524e0f19e2c09b048604347b9987ad09cc9578ab650920" => :high_sierra
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
