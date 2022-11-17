class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"
  license "FreeImage"
  head "https://svn.code.sf.net/p/freeimage/svn/FreeImage/trunk/"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "acdcf908bcc7bf5ce7fe7acf6c7d3de9787872c47687e25951411c07d86d7146"
    sha256 cellar: :any,                 arm64_monterey: "ec0035876daea1189f9e681ac3858c99270b6faab6c9701fe3d83333081feb9b"
    sha256 cellar: :any,                 arm64_big_sur:  "02080c0a6c32413b1e85f6e1393559426b77f0a7e5dcfda406617bc6e46a13e0"
    sha256 cellar: :any,                 ventura:        "57fd52efb2fe5109a77c46f42affd2192fc94acd0211d74a9045719e2ee54c9f"
    sha256 cellar: :any,                 monterey:       "8118801a64a4b47e2572b45935da12209fffea56393586a53186594f05071f58"
    sha256 cellar: :any,                 big_sur:        "948feca0476789f7061b3a0502aaa7820366a309ebad1abd73ff6b7a0c242402"
    sha256 cellar: :any,                 catalina:       "fabc22f3effecdb629ea6585e005aa09b9d3c3cf73fa0e3021370550e6f8832e"
    sha256 cellar: :any,                 mojave:         "f9b3f364e75ce8f0d61be663ef022d88a9b401d2d675599949ff9b19fbf39bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c63d08f4adf2395f983ad5f8a51f36ac1e749de9fe6428d056859b199ac6e6"
  end

  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
      sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
    end
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/freeimage/3.17.0-linux.patch"
      sha256 "537a4045d31a3ce1c3bab2736d17b979543758cf2081e97fff4d72786f1830dc"
    end
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
