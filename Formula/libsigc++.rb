class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.2/libsigc++-3.2.0.tar.xz"
  sha256 "8cdcb986e3f0a7c5b4474aa3c833d676e62469509f4899110ddf118f04082651"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ca2d52fb1e24a8e35968a9bb718a3917bb5c2f1aa1eaa7123095bf4e3fe73687"
    sha256 cellar: :any,                 arm64_big_sur:  "40565951d84f79588d1f5cd4fc49b1cd4cd1316f6f3159d3a3f2ed9b30b36546"
    sha256 cellar: :any,                 monterey:       "45dac0e6b63ceb87a02908dbc4d14bdd16d2ff6b1014df11de79b6331bfcef80"
    sha256 cellar: :any,                 big_sur:        "56de0ae0560072d9a069ce201f423906611eedbc971ca4e1fca9fb8a13efd22d"
    sha256 cellar: :any,                 catalina:       "d6b8cc8271b05ef6c7048e1344ee93f931469f05859ddde2bc67a112285da45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42bd65e6dd5d9a3b0126e8213e368e7b06cb9894991d25fff6b0d598ec6ae8cd"
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
