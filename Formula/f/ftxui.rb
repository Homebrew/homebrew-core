class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://github.com/ArthurSonzogni/FTXUI"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v6.1.7.tar.gz"
  sha256 "3df0e6e3dfc10193615bb42eff2bf17243e54d39c3a55bc9a6737de1953912bc"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43e131da77307e2d821862475ffc19abe5b9c1e5deaf2c0a4e8e23a32b768d4c"
    sha256 cellar: :any,                 arm64_sonoma:  "5ae886feb179dba64d7bf7abe9f9c6da85e73557c5f7d863d845f083f1d4aa9d"
    sha256 cellar: :any,                 arm64_ventura: "907524828d75c8312aa28ec0695e0c6884ef24799762f21286a5cac794409cc0"
    sha256 cellar: :any,                 sonoma:        "7b8f0d9e9506cb7315031a52270da314175fbddf4573d2f68315b0e3494ae1d5"
    sha256 cellar: :any,                 ventura:       "a28fd0c4cc55f959949c587ffe1f21c602967f784f8c101ea62d76dbc9a22c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da8e336bef055efab0ba1263942e90284560b7aba4dd151a06f05d97a85cc9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf48d26995804162af6612009efb446d06ebed2c2e9a81b00234950336fc1ed"
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
