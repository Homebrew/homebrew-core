class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://github.com/libsigcplusplus/libsigcplusplus/releases/download/3.8.1/libsigc++-3.8.1.tar.xz"
  sha256 "4ff41d1474e501d3baeced4c989d154338206ac16471e614376496b63fe252d1"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3540ac35660c59de1ea778b022c71db48bd21fe533d3707fb45a947d24852b1b"
    sha256 cellar: :any,                 arm64_sequoia: "0cc8533f02b5d8fafb85f22079c71cbdcb768bb92c5d8a0f12e03b01096ca36d"
    sha256 cellar: :any,                 arm64_sonoma:  "00137c00f53be1b785d9ecbfdb05419ecfb65cfdc4b7a56fe68df7c98a5c18d0"
    sha256 cellar: :any,                 sonoma:        "bf21d21308351da66080726b55e34755d2841ef1a3d9cd83c93224c13660032d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e202755e73e0652ec61a24af7010b2be577a5ac7f3f1cfaa41bc5b09c62ba0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611fb934eca5a1773b1874eba5cc214b7bc7a19ca64800a2edfbb42b55db232e"
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
