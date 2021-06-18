class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.8/gptfdisk-1.0.8.tar.gz"
  sha256 "95d19856f004dabc4b8c342b2612e8d0a9eebdd52004297188369f152e9dc6df"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9ddfc62f39c786868b5bcafb0cc949a89977ece0bf27eac038a70dbcd7772b8f"
    sha256 cellar: :any, big_sur:       "a16cd2748dcf4ce4a18caf1d09e04e077a456fe323553685ab07dc7b628567a7"
    sha256 cellar: :any, catalina:      "e5c8a8a789a75e2ff5cd3120922c0fa205ef3e9aec23fd77558a04b349283aea"
    sha256 cellar: :any, mojave:        "8ea2978e8d5612e21cef00d747ac24e0c5f44eeb5c9c2edcf926752bd389523a"
  end

  depends_on "popt"

  uses_from_macos "ncurses"

  # update linker path for libncurses
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
diff --git a/Makefile.mac b/Makefile.mac
index ea21fa6..b50bb34 100644
--- a/Makefile.mac
+++ b/Makefile.mac
@@ -21,7 +21,7 @@ gdisk:	$(LIB_OBJS) gpttext.o gdisk.o
 #	$(CXX) $(LIB_OBJS) -L/usr/lib -licucore gpttext.o gdisk.o -o gdisk
 
 cgdisk: $(LIB_OBJS) cgdisk.o gptcurses.o
-	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o /usr/local/Cellar/ncurses/6.2/lib/libncurses.dylib $(LDFLAGS) -o cgdisk
+	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o -L/usr/lib -lncurses $(LDFLAGS) -o cgdisk
 #	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o /usr/lib/libncurses.dylib $(LDFLAGS) -o cgdisk
 #	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licucore -lncurses -o cgdisk
