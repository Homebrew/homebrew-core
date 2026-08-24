class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://arthursonzogni.github.io/FTXUI/"
  url "https://github.com/ArthurSonzogni/FTXUI/releases/download/v7.0.3/source.tar.gz"
  sha256 "be506d647bf6eed2e7927f99ea080bcccff0938d9a35617756161d5b76df8b8a"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7ba2853c0c1b554fe08a209722f0fe1744dc1b907477fc14a6158470207abc8"
    sha256 cellar: :any, arm64_sequoia: "b9c336f9befa2aea3b617a8becf250f6fcdcbcf32a92b5bea0ceac2d28bafcac"
    sha256 cellar: :any, arm64_sonoma:  "36a50ba613e22e368b87da49fae4986d9ec4937d3ca85c60ced35d31ce22bcb0"
    sha256 cellar: :any, sonoma:        "25e58db7775bd02b7db74bf7e552e1aa74a6a6b84f7a43850fbcc8a5651dfc86"
    sha256 cellar: :any, arm64_linux:   "4cea70fe9cec4a8701a94da2d81f97a7dbf14738ee56e3a1238d70a575e4bdb5"
    sha256 cellar: :any, x86_64_linux:  "7fa7eecb23006402f9ce4dec901e011be9d56500f304aff751fe3c492deeff85"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFTXUI_BUILD_DOCS=OFF
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
