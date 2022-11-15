class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.2/libsigc++-3.2.0.tar.xz"
  sha256 "8cdcb986e3f0a7c5b4474aa3c833d676e62469509f4899110ddf118f04082651"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "86b758f24d784bac1a64350a46e9e597b6554c42408dcb3cf601e4aa76723be4"
    sha256 cellar: :any,                 arm64_monterey: "9391b249e2f7384c4720662739ef3de8f888c37c867be2ddb5bff7a1b2322399"
    sha256 cellar: :any,                 arm64_big_sur:  "072c1e58af5c3200b2c48909f5c8beed75ae5a55d0b17b64c05ad834cb96ab9b"
    sha256 cellar: :any,                 ventura:        "846b78f3cbf81e6473bd86c851a1ec10a5db493ca7a7d164da9c74f274fa2b0f"
    sha256 cellar: :any,                 monterey:       "7425858f43533a26ba8fe48ec525e1f43b9f0e52b2b2aed07cd24bd9f5282c12"
    sha256 cellar: :any,                 big_sur:        "18be15b790eb9c68fa9afd2348f2080db311fc48aa1ad89b7f230f4518fc09a1"
    sha256 cellar: :any,                 catalina:       "ba6e2306ae68fb9f730d041caa8df52a13425d94ab3d905fa92b8b202cbedac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cb554d8379a903baaf09a762afe79f86829ef9de076d53194b676a2acff291"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on macos: :high_sierra # needs C++17

  uses_from_macos "m4" => :build

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
