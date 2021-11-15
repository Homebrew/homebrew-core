class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "https://anttweakbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  livecheck do
    skip "Not maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "6eaad66c31e4ccddd3a87039cd99efc09fc757f12c59f13c7e6da2fd86070249"
    sha256 cellar: :any, arm64_big_sur:  "b4a716baa513d973f69724c84783e1a9644a1b5f2ca04640d9fd71da4c397fca"
    sha256 cellar: :any, monterey:       "317e87e85e95d094f79f12086db18ec61122f7780b0b8af9b41346540e2a2b6f"
    sha256 cellar: :any, big_sur:        "438ba46ecc4b5f2d77b58281c4ae004c7e255710240f0b498322c55acae08618"
    sha256 cellar: :any, catalina:       "38b3f17cf22401dd83d9f2ea375b14b31fbd011e0e2b6cbb8b5be894ac49db0b"
    sha256 cellar: :any, mojave:         "2e68286a46381829f51a5bb91eb03bcdc876b79445c86672395517b4f3322652"
    sha256 cellar: :any, high_sierra:    "393b87de789337afebed9196404af46fa660fea3b476d874d77b48bb35c8079b"
    sha256 cellar: :any, sierra:         "af510970b310b01ee52528e816cdd53e2d4a4e2cfc76e426b1710f758bc99d20"
    sha256 cellar: :any, el_capitan:     "417278abe012967efcf22b0276527187f6472dd5fd4d271b1ea32604816d46c9"
    sha256 cellar: :any, yosemite:       "a2e29104a5ef51621faaebd72ccc39bd5fe7bd6e977af74a358c5cc83c65c2c2"
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    # Work around Xcode 9 error "no member named 'signbit' in the global
    # namespace" and Xcode 8 issue on El Capitan "error: missing ',' between
    # enumerators"
    if DevelopmentTools.clang_build_version >= 900 ||
       (MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0")
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT")
    end

    system "make", "-C", "src", "-f", "Makefile.osx"
    lib.install "lib/libAntTweakBar.dylib", "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <AntTweakBar.h>
      int main() {
        TwBar *bar; // TwBar is an internal structure of AntTweakBar
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-anttweakbar", "-o", "test"
    system "./test"
  end
end
