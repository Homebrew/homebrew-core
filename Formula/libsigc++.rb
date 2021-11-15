class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.7.tar.xz"
  sha256 "bfbe91c0d094ea6bbc6cbd3909b7d98c6561eea8b6d9c0c25add906a6e83d733"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7a9ae8e63d6d8512caef0cc85de5e6ec6a3c109dcb23fbbc6f7e4a7d20f7d95"
    sha256 cellar: :any,                 arm64_big_sur:  "8cec1498075efde0b642bc9fb942f3311fa06cba220abe9d362ee3a7d5e9e4b6"
    sha256 cellar: :any,                 monterey:       "c823c0dfdfad8b71692062ee9e473a0e0a0893bd0071d90ed07987a0dceea79c"
    sha256 cellar: :any,                 big_sur:        "a6cbe2301ae3a6453a595f8ef6af01178b2abac4509ab56056636d9d52ebee07"
    sha256 cellar: :any,                 catalina:       "11a842cc1940fe07eac5f4c28de62348c9a4c2aa3ae7d024a44e0f16f83409f0"
    sha256 cellar: :any,                 mojave:         "5329e6dd054b51c9dcae16be93635dab3af249f671717d4894b1866a5b5efdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfe2ea60d780948d5c7ca21d2750b41c2fc308f9279bc3eed852a7f096d8d57"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on macos: :high_sierra # needs C++17

  on_linux do
    depends_on "m4" => :build
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
