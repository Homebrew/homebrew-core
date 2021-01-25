class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"
  license "FreeImage"
  head "https://svn.code.sf.net/p/freeimage/svn/FreeImage/trunk/"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 3
    sha256 "948feca0476789f7061b3a0502aaa7820366a309ebad1abd73ff6b7a0c242402" => :big_sur
    sha256 "02080c0a6c32413b1e85f6e1393559426b77f0a7e5dcfda406617bc6e46a13e0" => :arm64_big_sur
    sha256 "fabc22f3effecdb629ea6585e005aa09b9d3c3cf73fa0e3021370550e6f8832e" => :catalina
    sha256 "f9b3f364e75ce8f0d61be663ef022d88a9b401d2d675599949ff9b19fbf39bc0" => :mojave
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
    sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
  end

  def install
    # Temporary workaround for ARM. Upstream tracking issue:
    # https://sourceforge.net/p/freeimage/bugs/325/
    # https://sourceforge.net/p/freeimage/discussion/36111/thread/cc4cd71c6e/
    ENV["CFLAGS"] = "-O3 -fPIC -fexceptions -fvisibility=hidden -DPNG_ARM_NEON_OPT=0" if Hardware::CPU.arm?
    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "PREFIX=#{prefix}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <FreeImage.h>
      int main() {
         FreeImage_Initialise(0);
         FreeImage_DeInitialise();
         exit(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfreeimage", "-o", "test"
    system "./test"
  end
end
