class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/releases/download/3.0.0/fmt-3.0.0.zip"
  sha256 "1b050b66fa31b74f1d75a14f15e99e728ab79572f176a53b2f8ad7c201c30ceb"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b1ef0852ab31be3d350262d4a002a3a0de4d99191454968607b629d6728a034" => :el_capitan
    sha256 "e8a3d6249d417f6a56e012b7327239ba5ab1993264260a612b5108e017cb5c66" => :yosemite
    sha256 "eaf14af839288acc850ac113ccd9116cb51e1366344d4c2e17d8b1070bd29aa6" => :mavericks
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
