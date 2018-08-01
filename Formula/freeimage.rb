class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"

  bottle do
    cellar :any
    sha256 "a98fcfcbb82364d411ec11861f0523ea4e7dfd789d7e80fe1e1bdcb337ef3006" => :high_sierra
    sha256 "c3489ce29935ad196057e6ff95485dfc4442e7e26c4031523623e28bb587fad3" => :sierra
    sha256 "910ae7448a650a9415ad61e86635daed39177537f891a16bd036f444c96bdbfb" => :el_capitan
    sha256 "aec3219d5a015a5df4fbc81da4d74ac3c2a6f2d528bfbca770c217775f065e19" => :yosemite
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
    sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
  end

  def install
    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "PREFIX=#{prefix}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
