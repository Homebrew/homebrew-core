class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.6/gptfdisk-1.0.6.tar.gz"
  sha256 "ddc551d643a53f0bd4440345d3ae32c49b04a797e9c01036ea460b6bb4168ca8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "bdaeba66200ebc8a588676918a6c6180ef52e87bce17b28177a90f5aa0c3e2ef" => :big_sur
    sha256 "7dd969dec0e8d7176de929401fb68e5fecfe1bec9346697f99a9ec1727bfd090" => :arm64_big_sur
    sha256 "b0232add041d99be5213600609a9bb21ba8ba31830c50bcc16f3870ee8cc4c80" => :catalina
    sha256 "a827e15b756b188b6c23b8447d4b41668d328b00f8e85eee84d55d2a895ab091" => :mojave
  end

  depends_on "popt"

  uses_from_macos "ncurses"

  # Fix Big Sur compilation issue with 1.0.5; the physical *.dylib files
  # are no longer present directly on the filesystem, but the linker still
  # knows what to do.
  patch :DATA

  def install
    system "make", "-f", "Makefile.mac"
    %w[cgdisk fixparts gdisk sgdisk].each do |program|
      bin.install program
      man8.install "#{program}.8"
    end
  end

  test do
    system "dd", "if=/dev/zero", "of=test.dmg", "bs=1m", "count=1"
    assert_match "completed successfully", shell_output("#{bin}/sgdisk -o test.dmg")
    assert_match "GUID", shell_output("#{bin}/sgdisk -p test.dmg")
    assert_match "Found valid GPT with protective MBR", shell_output("#{bin}/gdisk -l test.dmg")
  end
end

__END__
diff -ur a/Makefile.mac b/Makefile.mac
--- a/Makefile.mac	2020-02-17 22:34:11.000000000 +0000
+++ b/Makefile.mac	2020-12-05 22:12:04.000000000 +0000
@@ -21,7 +21,7 @@
 #	$(CXX) $(LIB_OBJS) -L/usr/lib -licucore gpttext.o gdisk.o -o gdisk
 
 cgdisk: $(LIB_OBJS) cgdisk.o gptcurses.o
-	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o /usr/lib/libncurses.dylib $(LDFLAGS) $(FATBINFLAGS) -o cgdisk
+	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o -L/usr/lib -lncurses $(LDFLAGS) $(FATBINFLAGS) -o cgdisk
 #	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licucore -lncurses -o cgdisk
 
 sgdisk: $(LIB_OBJS) gptcl.o sgdisk.o
