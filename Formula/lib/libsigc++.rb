class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.4/libsigc++-3.4.0.tar.xz"
  sha256 "02e2630ffb5ce93cd52c38423521dfe7063328863a6e96d41d765a6116b8707e"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0fb17058bedd65330df38f7d9205998b20402e2083182c5e475b8b798a59d573"
    sha256 cellar: :any,                 arm64_ventura:  "4a37ac08451ee4f8800a22535aad6c71ef0c1ce11cc3e0c03cfb38d6b2c3e946"
    sha256 cellar: :any,                 arm64_monterey: "4a48debb678cfe3cd37b1252a1f49611b2388626efa5571d82b71039af93f42c"
    sha256 cellar: :any,                 arm64_big_sur:  "7d0cb8f96273a8d0a322b386bbd790bb354c510a2755f2dd49d061a08d8222be"
    sha256 cellar: :any,                 sonoma:         "034c98caf34e0c02cb6223bdbea32a457cb279afac3920ed2bf61840dfe6984a"
    sha256 cellar: :any,                 ventura:        "fb6d56a43b68ac039b5f9a54bccae5b40800f597ad106d53f5ead0e0fda0cb7b"
    sha256 cellar: :any,                 monterey:       "cec86624a9048448189a4c42aab0486eb26483d5edd335518c4d976020a417ed"
    sha256 cellar: :any,                 big_sur:        "027a7496473703fe38480c3fa1d773fec1265211f237c55aa10be53bdd1cf860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5762b879dc561dd61ca5f7744d977dbe2f2294406dd1b4432e23974f9a0469a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on macos: :high_sierra # needs C++17

  uses_from_macos "m4" => :build

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", "-Dbuild-tests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <sigc++/sigc++.h>

      void on_print(const std::string& str) {
        std::cout << str;
      }

      int main(int argc, char *argv[]) {
        sigc::signal<void(const std::string&)> signal_print;

        signal_print.connect(sigc::ptr_fun(&on_print));

        signal_print.emit("hello world\\n");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
