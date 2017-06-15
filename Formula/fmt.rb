class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/3.0.2.tar.gz"
  sha256 "fa4a062897b2f3712badfdb8583e6d938252e1156cb5705c3af87705dfef3957"

  bottle do
    cellar :any_skip_relocation
    sha256 "bac53b7d6efc3f09ddbb5e197aa6ea8f0337010b396f75bb51666bb9f1f4b250" => :sierra
    sha256 "49151a813dd32732427993f0279620986b4371ec841ebdd506c77f4def10cd12" => :el_capitan
    sha256 "91122df1a848016cf728ef1fe60fb18edae3f4fe99766eb93043bb6148b69259" => :yosemite
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
