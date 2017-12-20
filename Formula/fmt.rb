class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/4.1.0.tar.gz"
  sha256 "46628a2f068d0e33c716be0ed9dcae4370242df135aed663a180b9fd8e36733d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dfcbf41403abf9942202a7b96afc0ade48b7aba58db5bdbafd53c0598eb7aed" => :high_sierra
    sha256 "bbc85439060bd61a32e51f81cc9f85a9dffa33ce469be41202267e6389886e64" => :sierra
    sha256 "834e3662962513589804942894ced8d5dc5dfbb98d557060da8b6b071acba6ef" => :el_capitan
    sha256 "5f6b23785f1fa87dce60777a0ed77381d7307b9116fdf60e0aa2dbb23e542852" => :yosemite
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

    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
