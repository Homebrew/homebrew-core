class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.5/gptfdisk-1.0.5.tar.gz"
  sha256 "0e7d3987cd0488ecaf4b48761bc97f40b1dc089e5ff53c4b37abe30bc67dcb2f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "7764d3c435876ddc2d8c2fc67ac033f1fae3343967844254deaa3854adf62285" => :catalina
    sha256 "7764d3c435876ddc2d8c2fc67ac033f1fae3343967844254deaa3854adf62285" => :mojave
    sha256 "d68f15fdff5ea9385e68129a209c8d2de1f9525a114637e8b361caf06bf4e482" => :high_sierra
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
