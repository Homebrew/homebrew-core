class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/5.3.0.tar.gz"
  sha256 "defa24a9af4c622a7134076602070b45721a43c51598c8456ec6f2c4dbb51c89"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6a39e2796b7523e54fb1ec230ff1c6fdf6e714a493825eb7ed513f779ca8933" => :mojave
    sha256 "7c8f486045939dfd05722542393a9282b51d61dfee285619e6a7d4e86421a1b7" => :high_sierra
    sha256 "ba2fc17744a773880fb456ec07ef6985d02a60d9399c40214fe2574460331ce3" => :sierra
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
