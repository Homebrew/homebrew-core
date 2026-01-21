class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://github.com/libsigcplusplus/libsigcplusplus/releases/download/3.8.0/libsigc++-3.8.0.tar.xz"
  sha256 "502a743bb07ed7627dd41bd85ec4b93b4954f06b531adc45818d24a959f54e36"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e34388e22fe43082e4eec509563daebb6c22e4741b951c1f7e51ca9dbfc6c1cb"
    sha256 cellar: :any,                 arm64_sequoia: "69d7a7c6111cc2e15c79ec3a6b1f7665478352d546f6b53e8a3abc825061dc1f"
    sha256 cellar: :any,                 arm64_sonoma:  "6e0659fd1db91fa0983ef291bdfc361a57ae481fa58157f3a4601b671839a45e"
    sha256 cellar: :any,                 sonoma:        "9252bbe32c72a9648b1a1310e6c66951ef7c8d2d864fcbcb70b7776ad057b117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d5977874a94340f0762a03848e4d1bb0c2f892b1c0cd2547113ffdc95f582ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da465553d96b4047d92ffb26069a6beba6c4b8ee03c1372a257d463e7ede8cea"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "m4" => :build

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", "-Dbuild-tests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
