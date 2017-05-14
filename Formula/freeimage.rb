class FreeimageHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    # need to convert newlines or patch chokes
    quiet_safe_system "/usr/bin/unzip", { :quiet_flag => "-qq" }, "-aa", cached_location
    chdir
  end
end

class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.17.0/FreeImage3170.zip",
    :using => FreeimageHttpDownloadStrategy
  version "3.17.0"
  sha256 "fbfc65e39b3d4e2cb108c4ffa8c41fd02c07d4d436c594fff8dab1a6d5297f89"
  revision 1

  bottle do
    cellar :any
    sha256 "6eb482ca66b05f05b48bbb2fa5aad2cb971f3c767145b0a88baed5eff36e355c" => :sierra
    sha256 "ab4f64a25cf6ec07019ae8a1dac9d6f5f10462962992cc3b822145506b8ac513" => :el_capitan
    sha256 "3b9bf4ed62d4d0d88daa301cf5c183d16474d1a0957a14fffc2ead3d0d88ecb8" => :yosemite
    sha256 "d7d197266815f5f3d732c9afd66055e7abf49362d7449bfea21e3aa358e5a4a1" => :mavericks
    sha256 "9d1e914ae20deb7066caf5f1cf52c3d48c0c04ccd36b791170c7e1fcb3528a36" => :mountain_lion
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
    sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
  end

  # fix GCC 5.0 compile.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f2b4fb19/freeimage/gcc5.diff"
    sha256 "da0e052e2519b61b57fe9f371b517114f8be81dd2d3dd1721b8fb630dc67edff"
  end

  def install
    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "PREFIX=#{prefix}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
