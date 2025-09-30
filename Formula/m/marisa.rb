class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https://github.com/s-yata/marisa-trie"
  url "https://github.com/s-yata/marisa-trie/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "986ed5e2967435e3a3932a8c95980993ae5a196111e377721f0849cad4e807f3"
  license any_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6975b75a559edc43c0638facb994e1cf76648e1fee7eefd5d28137a04790fbb"
    sha256 cellar: :any,                 arm64_sequoia: "6c21f4fbe4ade8b27886f8b0ecad9abbdcf366609768725dccdc4abe0cd61cec"
    sha256 cellar: :any,                 arm64_sonoma:  "5d76e8c461645adfa364dc4baba23329ec6b704887c61dcd58a3803c2e4ea644"
    sha256 cellar: :any,                 arm64_ventura: "ff6a486605dcf49fbbe46cf3209099281767050d9e5e0a8d1183f0e82a331c33"
    sha256 cellar: :any,                 sonoma:        "c874e717b5012f666806f8e694fea477e64a923962fea32b721162274570010b"
    sha256 cellar: :any,                 ventura:       "9716999cd08310e683e4ad449ad760f1ba00d1f48f0baab33a0c938c7cd9e458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628a8b2d7534358ee7ca62275a44d99fd366f1d3ae16e43a683646d2e92bac3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945704062b08f0b172336f276cef502bb5d399a57b2c0aad9ce79d56f9fd8c65"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                     "-DBUILD_SHARED_LIBS=ON",
                     "-DCMAKE_INSTALL_RPATH=#{rpath}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, "-std=c++17", "./test.cc", "-o", "test"
    assert_equal "200,100", shell_output("./test").strip
  end
end
