class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "https://anttweakbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "6825d7d72639e43a4ba9aa648201118ef8e3f55b5163c809291ac233451d1dbe"
    sha256 cellar: :any,                 arm64_monterey: "9178f704ca8362c50459ca7e1462af63992b98c3b60cada7dc7e319e69a4ba70"
    sha256 cellar: :any,                 arm64_big_sur:  "75d39f323508a11e1ff67dac8692f37ebf3d64cba4e56b85ca75fa0f791064fb"
    sha256 cellar: :any,                 ventura:        "c48ff7c8f2cf4cc1cab4d5dbde74aef786b6faffcff6501e01be8e3af132613f"
    sha256 cellar: :any,                 monterey:       "3582f931cc81be3964818954bd10333d642445d4ac141bb862d1d41073192d9f"
    sha256 cellar: :any,                 big_sur:        "eb3e1568d7e20aefcc105b35667a415f449246e8eb5cc1bc997110c7adf1aa0d"
    sha256 cellar: :any,                 catalina:       "4987c69c018c37bb0165f080d36f785c5454818cc529583a53a03088615759fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae09470f66b8f8d6d6aae8125cc871565ab2fe349d5fc293c8e5534f90b8d1fc"
  end

  # From https://sourceforge.net/projects/anttweakbar/:
  # "The project is not maintained anymore but feel free to download
  # and modify the source code to fit your needs or fix issues."
  deprecate! date: "2023-02-14", because: :unmaintained

  on_linux do
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    makefile = OS.mac? ? "Makefile.osx" : "Makefile"
    system "make", "-C", "src", "-f", makefile
    lib.install shared_library("lib/libAntTweakBar"), "lib/libAntTweakBar.a"
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
    system ENV.cc, "test.cpp", "-L#{lib}", "-lAntTweakBar", "-o", "test"
    system "./test"
  end
end
