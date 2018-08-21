class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.10.tar.bz2"
  sha256 "96773e72903b00d73e68ba9d5f19744a91ed46d27acd511a10eb23533589777d"

  bottle do
    cellar :any_skip_relocation
    sha256 "645c0b42475bb4d09c2c27219e80ffc3fed4c34b72c5f6bb0e8534cba1101ea2" => :mojave
    sha256 "eb519c8f3fb9b2773529d5e7a9751cec7e2a7a67a76af92cab0e6b48449dc6de" => :high_sierra
    sha256 "73e502b5331d28da40fc3b94763f6ea30a141e48329bede7eddf3e396991671b" => :sierra
    sha256 "a5db5b2309de19ea395efaafcf828c253e38133464faca623545a221f2b0ba52" => :el_capitan
  end

  # Fixes compile error with Xcode-4.3+, a hardcoded /Developer.  Reported as:
  # https://sourceforge.net/p/matroska/bugs/9/
  patch :DATA if MacOS.prefer_64_bit?

  def install
    system "./mkclean/configure"
    system "make", "mkclean"
    bindir = `corec/tools/coremake/system_output.sh`.chomp
    bin.install Dir["release/#{bindir}/mk*"]
  end

  test do
    output = shell_output("#{bin}/mkclean --version 2>&1", 255)
    assert_match version.to_s, output
  end
end

__END__
--- a/corec/tools/coremake/gcc_osx_x64.build	2017-08-22 06:38:25.000000000 -0700
+++ b/corec/tools/coremake/gcc_osx_x64.build	2017-11-18 22:53:56.000000000 -0800
@@ -4,11 +4,10 @@
 
 PLATFORMLIB = osx_x86
 SVNDIR = osx_x86
-SDK = /Developer/SDKs/MacOSX10.5.sdk

 //CC = xcrun --sdk macosx clang
 
-CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic -mmacosx-version-min=10.5
+CCFLAGS=%(CCFLAGS) -arch x86_64 -mdynamic-no-pic
 ASMFLAGS = -f macho64 -D_MACHO -D_HIDDEN
 
 #include "gcc_osx.inc"
