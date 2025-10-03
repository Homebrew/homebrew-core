class Ftxui < Formula
  desc "C++ Functional Terminal User Interface"
  homepage "https://github.com/ArthurSonzogni/FTXUI"
  url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v6.1.9.tar.gz"
  sha256 "45819c1e54914783d4a1ca5633885035d74146778a1f74e1213cdb7b76340e71"
  license "MIT"
  head "https://github.com/ArthurSonzogni/FTXUI.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adf940aea1828f7238f701f4662016c1664347b830bba7463b50a40c2f0e7407"
    sha256 cellar: :any,                 arm64_sequoia: "5b3e3442ed075b99e3604bea2a515ebb1cbbd9d806386e040d925d38a54692f8"
    sha256 cellar: :any,                 arm64_sonoma:  "04064b1363f454f0f9cbbbeb16d98d8d5fef2daf3e0bef0c5e168a73e8b54b89"
    sha256 cellar: :any,                 arm64_ventura: "2ea1f6c02f9a1c4cf135a928a6dd9c4ee0e839b113307f436963558c5acd3007"
    sha256 cellar: :any,                 sonoma:        "dd41f7868452173504be6f2786966ed4836c1531d06c7f1f9c3b46fb8b587ba9"
    sha256 cellar: :any,                 ventura:       "798c20dcbe2d7f97f44a52237d58d7097c3b80fb879427fc6be532467277f8f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf56dd804ae10402637a259399706b18d9db65477f5472282181c8beff69f9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26a35edfd086bb2cdc76b5e8d699094882a633285a4a2ead8323bb8bb2fc9b78"
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
