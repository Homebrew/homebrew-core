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
    sha256 "c3489ce29935ad196057e6ff95485dfc4442e7e26c4031523623e28bb587fad3" => :sierra
    sha256 "910ae7448a650a9415ad61e86635daed39177537f891a16bd036f444c96bdbfb" => :el_capitan
    sha256 "aec3219d5a015a5df4fbc81da4d74ac3c2a6f2d528bfbca770c217775f065e19" => :yosemite
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
