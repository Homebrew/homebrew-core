class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.8.10.tar.bz2"
  sha256 "96773e72903b00d73e68ba9d5f19744a91ed46d27acd511a10eb23533589777d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c201a3f6f75dab3a3078e382999d479d19556049248f0451143bd8cc1b97e16d" => :high_sierra
    sha256 "3a8eb240bf72923753f39652fb68ba47c02481e307d914173550e8bd4516e767" => :sierra
    sha256 "f8628b1bfb08d1624faa2037d199592bc6209759322bcfc53eb5649ad304e4bd" => :el_capitan
    sha256 "cefecf33d4cb9fa15d582b0d03c26cf3a14228d02832ddbf3187d5c4ffd4a4c2" => :yosemite
    sha256 "51b53b0e49a5fe451c6bd3589e780e51ac23c637493c8804233057cb79b9d40d" => :mavericks
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
