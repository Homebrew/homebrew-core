class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.6/libsigc++-3.6.0.tar.xz"
  sha256 "c3d23b37dfd6e39f2e09f091b77b1541fbfa17c4f0b6bf5c89baef7229080e17"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7584f429685f4303440447588525e5259681cc7c08b2e53d80757c4c9aadd1c3"
    sha256 cellar: :any,                 arm64_sequoia:  "e481f54a00978ae4fdd3c377bacfb99fb5f890ff914791151a514ce7a6ebfadb"
    sha256 cellar: :any,                 arm64_sonoma:   "1dafdacabb0f20c0f95af6338147c4ffb65d4e516670786b995091364fa9c110"
    sha256 cellar: :any,                 arm64_ventura:  "ea969d674fc75a2c00d3949275f22c54cb3bff8c3f172e0fa7504eb8c5a43e33"
    sha256 cellar: :any,                 arm64_monterey: "d8da5f7b72add1164baa9dea85cf98252e453d6feccdc810a83e45864015a4a6"
    sha256 cellar: :any,                 sonoma:         "2b8440fee6119c2db8798127a2ba79a0661d704cce7ad9981f8379ac425390dd"
    sha256 cellar: :any,                 ventura:        "14caa93cc34a8fc23b59970bd16fcb6750d06455a1077dbdc4b019484cc1f25a"
    sha256 cellar: :any,                 monterey:       "00a4b40549db35b1c86c7c4dbec7ce12fac4984a6978dd23f3a64f99dd55e789"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0ec3e71db039808ea08a34d73e13d2bceb915dcdb0069f4da98478afe501e0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125217bab99e1e8e4752ddcbe720f68745ffaadc94930cbd432d554a87c7924f"
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
