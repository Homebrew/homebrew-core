class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://github.com/ArthurSonzogni/FTXUI"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v6.1.8.tar.gz"
  sha256 "bf9166bcc9425ec38f98c864150666356fb2673b47b63e1647f5acccc6787d0d"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abf9d457dabbb11a19039ebabf345292c6f33d76ec6287a89b1fa440739e29d4"
    sha256 cellar: :any,                 arm64_sonoma:  "0b1e38e32479461739b41e01b4ee9fb0e63570c87b006fa62876cffe712f4ee2"
    sha256 cellar: :any,                 arm64_ventura: "63f418d1badbe327f90b018a7c74e3fe2f55cb2b0464764335cecf66220e1463"
    sha256 cellar: :any,                 sonoma:        "1db4e6052ba59bb7c5309f17530189e91368ab20916098eb016a968a71635490"
    sha256 cellar: :any,                 ventura:       "6cdbee455c90145316815e72c2977a845329d5f317b4492bcd8f0783d17eac47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc61d939599a72b21662e7cff91ec619a9036055a95a983ccf52b92c52b0e21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a683a44515eea925fb2aa9d3841a9756759ce65ebd6687f89919e37a8fa6df1"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFTXUI_BUILD_DOCS=ON
      -DFTXUI_BUILD_EXAMPLES=OFF
      -DFTXUI_BUILD_TESTS=OFF
      -DFTXUI_QUIET=ON
      -DFTXUI_ENABLE_COVERAGE=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ftxui/dom/elements.hpp>
      int main() {
        using namespace ftxui;
        auto summary = [&] {
        auto content = vbox({
          hbox({text(L"- done:   "), text(L"3") | bold}) | color(Color::Green),});
          return window(text(L" Summary "), content);
        };
        return EXIT_SUCCESS;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
