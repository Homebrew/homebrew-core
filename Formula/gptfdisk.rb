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
    sha256 "a3e4b6f68aba2aca20a6a197613e662af80a84a71765f7cdc9760ea495d00a86" => :big_sur
    sha256 "dfe0b4cbc0e2cb2118fb2fbbbcd3ad1d42ff9fad8c7ad785c7a27bfd8cc48c5f" => :arm64_big_sur
    sha256 "b3fc1b140c2a2c4b713460483134620b61066d351a4bdd5a1adc5dfe9c53f1be" => :catalina
    sha256 "9d8b7f91e699513e4c6c42d4b8e56548f93d76d0e30da1d09b8f9725d49d0f15" => :mojave
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
