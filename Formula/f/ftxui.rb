class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://arthursonzogni.github.io/FTXUI/"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "14bef1f8caff548c49af8eeadfca21910d66e93e68237f0c3d20236b60c01e7e"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4af7d86552e7a549970fe0e49fc68249771356a8612f48d0e8914d8a0be526ba"
    sha256 cellar: :any, arm64_sequoia: "f75973c6e9f3eda9f97478a5d2b49916a42b913dd728e34a8f4bb105cc90c3c7"
    sha256 cellar: :any, arm64_sonoma:  "c8ec8a62a9c54c7a5077fe0b210b794286c632c2e5669a41bc595a1b6469b33d"
    sha256 cellar: :any, sonoma:        "aa03722fb9703b014924a98505804e1cee1e928e2f0b2bd1d2deadfac24cff41"
    sha256 cellar: :any, arm64_linux:   "e042cf6ebbb53936ec5d9e6155649c284532b7d066704f88a1575566b08437fd"
    sha256 cellar: :any, x86_64_linux:  "3fcc617bd69dd3fcea9eb292dce5ac46b0cae40ea4ae042957d79c171b04afc8"
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
