class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/7.1.3.tar.gz"
  sha256 "5cae7072042b3043e12d53d50ef404bbb76949dad1de368d7f993a15c8c05ecc"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e2c6b979c98bf19cb19f47a917f8509bca5d4e05443cec7f02f3dd632d6d497c" => :big_sur
    sha256 "4eff1df21244a32d96b90a2dab162c18b8c3997da45c9c54f264776faf6a7457" => :catalina
    sha256 "134d913dcd75ae766f8a887086538be4f8f0a9e13c9e4989d731cd8c2117806e" => :mojave
    sha256 "a3cd11e35eab43f36608513a2c2904acce9336a0d46cb3ddd37cc00dfd258523" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
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
