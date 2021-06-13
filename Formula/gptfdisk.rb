class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.8/gptfdisk-1.0.8.tar.gz"
  sha256 "95d19856f004dabc4b8c342b2612e8d0a9eebdd52004297188369f152e9dc6df"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3535bc75dd24cedf66a610a704c79ec076f310afab49144cb14c888cc2bca658"
    sha256 cellar: :any, big_sur:       "09ca482952e2537ad9fd35f7f29fea209229e5598a9dcf76b0bae66ba0dd23c5"
    sha256 cellar: :any, catalina:      "fd7441f59bb4ec83893e163d98c5b0ccf6a6685d6956feace396851341f02c89"
    sha256 cellar: :any, mojave:        "ce9c53f927d62937990612de247e725bf0d72e533acae25b73d7383481ded82a"
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
