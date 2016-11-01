class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/3.0.1.tar.gz"
  sha256 "dce62ab75a161dd4353a98364feb166d35e7eea382169d59d9ce842c49c55bad"

  bottle do
    cellar :any_skip_relocation
    sha256 "64594784bf98259bc0e08499b03d65395b849f2db5e132b7d885b4dcae1893cd" => :sierra
    sha256 "89e5da4b7ccda59c840406b830b547b50e9621ec73524ec9d90bdec95087c115" => :el_capitan
    sha256 "713dd1a92c1e3509c9bd67b0f72cbf4141923288188ffc0630648981c3239c3c" => :yosemite
    sha256 "0f563f0c3bb0e8425fc4d4dd48d5e493eb2a2e6301fb7eb2e0e646d1dd2f12ca" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
