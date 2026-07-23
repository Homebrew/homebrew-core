class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://arthursonzogni.github.io/FTXUI/"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "80f544bb47fab24d3e57bc561324da228c050b3f2e8683fe806883ca5cd561a2"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ee4c5c88db892c380cac52185e2514460d3fc0616c1b6e2c281890797b06beb"
    sha256 cellar: :any, arm64_sequoia: "5e31de9c335f8635a6e5d99355ca2ee99dbb4d0a4dcb650070846670d8fc486d"
    sha256 cellar: :any, arm64_sonoma:  "924df0f74c37226dfdbc5c50254634d02ee41407728d39e99a1ba53a01599fc6"
    sha256 cellar: :any, sonoma:        "f23600f9ba5990aba27cc64d9312badbd1ab86497e7f1cbba4e333166cd2784d"
    sha256 cellar: :any, arm64_linux:   "767beaeb9c7e54b59b13e211add2ddf5f1e304b8618154145989cbba4f0250c8"
    sha256 cellar: :any, x86_64_linux:  "2e3c7ba2002e0b0241bb4a4d04da0f5a1bd58fa961aa9c476863d296ecd89716"
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
