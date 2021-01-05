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
    rebuild 2
    sha256 "468acef9f22a474ce87a95ae6f6ec96f1b11495fa04258c47d73c2bf5aa571ef" => :big_sur
    sha256 "2c2575c037f36b9f4d6bbef4f1de69aec114b5630f3de9f3eb23afb185ce9183" => :arm64_big_sur
    sha256 "f822ee25eee740ea83447986823f233bfdc8e5014c5299cd55ea7f8ae6a58c54" => :catalina
    sha256 "3402d2a116db186d2c4dfee8665ecdf1f0e1a24620b462e760c386572371c94e" => :mojave
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
