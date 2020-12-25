class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"
  license "FreeImage"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "3cd5e0aa1f14c7895f9fff9ce6f08dc2283efbbe29467155e1f1dfba8c500ad5" => :big_sur
    sha256 "75e29ff6d4b7ebf62e9ef610f60bd8521cd749a57d2a2d5c967685a7b8c7e998" => :catalina
    sha256 "8d8b14e27793669cd6d43bbb5956c312301e94562f0f5bfb8ee88709d4deed83" => :mojave
    sha256 "fbb88260ac76a166399deca5b8fa4eb23fbbb02cbecaf418c8310d3d7b6fb192" => :high_sierra
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
    sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
  end

  def install
    if Hardware::CPU.arch == :arm64
      ENV.append "CFLAGS", "-DPNG_ARM_NEON_OPT=0"
      ENV.append "CXXFLAGS", "-DPNG_ARM_NEON_OPT=0"
    end
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
