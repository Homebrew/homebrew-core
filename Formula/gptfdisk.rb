class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.7/gptfdisk-1.0.7.tar.gz"
  sha256 "754004b7f85b279287c7ac3c0469b1d7e0eae043a97a2e587b0560ca5f3828c0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dfe0b4cbc0e2cb2118fb2fbbbcd3ad1d42ff9fad8c7ad785c7a27bfd8cc48c5f"
    sha256 cellar: :any, big_sur:       "a3e4b6f68aba2aca20a6a197613e662af80a84a71765f7cdc9760ea495d00a86"
    sha256 cellar: :any, catalina:      "b3fc1b140c2a2c4b713460483134620b61066d351a4bdd5a1adc5dfe9c53f1be"
    sha256 cellar: :any, mojave:        "9d8b7f91e699513e4c6c42d4b8e56548f93d76d0e30da1d09b8f9725d49d0f15"
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
