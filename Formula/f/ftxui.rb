class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://github.com/ArthurSonzogni/FTXUI"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v6.0.2.tar.gz"
  sha256 "ace3477a8dd7cdb911dbc75e7b43cdcc9cf1d4a3cc3fb41168ecc31c06626cb9"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af05df19efa91d46d6a93c906de707aecfa749634e786937c262ad3a77a39f68"
    sha256 cellar: :any,                 arm64_sonoma:  "531be08751484686f71f359cbc621d3ecbeea8b137e2dfa8a53a7d7512f0aaae"
    sha256 cellar: :any,                 arm64_ventura: "8dc0bb17ff94cad0c42c10b46512207303359149f8d7362edca99dad63a08499"
    sha256 cellar: :any,                 sonoma:        "4085804f59cf1c50741e8f3a2747ab035553f5e207f9277d0db01116e0dd8bee"
    sha256 cellar: :any,                 ventura:       "c869aaf1aa5a002275acfd70095f2e6afa4021adbbaa8668466f8c679d9c6866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d95f9c0e7da4ddff0c75c87805412d9d6d984ac4be0fb5624788666d68dd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c5f0e57e1d18e2e1aede1f9708242b3542bde0035d918f73bfee714a45002f"
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
