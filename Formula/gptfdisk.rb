class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.9/gptfdisk-1.0.9.tar.gz"
  sha256 "dafead2693faeb8e8b97832b23407f6ed5b3219bc1784f482dd855774e2d50c2"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44695b26f0c6573bef6f0e5406d57364f4a146963a7fc70ffda70785ba5d81a8"
    sha256 cellar: :any,                 arm64_monterey: "c441169bd2c41b16caa519843b2b8dc4a827842483d335b5c02b1b5bffd92766"
    sha256 cellar: :any,                 arm64_big_sur:  "1e5f4146ffa1a68c58f24792e12c54abd60f5fefef34cb2554b3e36837ea6c0a"
    sha256 cellar: :any,                 ventura:        "f0ae2fa9ab790995bccdcdbc1c71f50ef64dbb2b292175b58a1f5427fa55a0ab"
    sha256 cellar: :any,                 monterey:       "97dbd19ad14e804d46a12b60d9f75490f7074403609cd9645e69ec1e970c5cc3"
    sha256 cellar: :any,                 big_sur:        "9f36a4ef4536d2692770ef30a4e2eb13e1ab29142d3431fafda1167cbc4ad1a6"
    sha256 cellar: :any,                 catalina:       "232fa946d22e2929d7021ba28e088856cb8542126bcf939fbedc2a99d8f1bf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d662db01992e4c3c8a077c1dd0883c741db35ec8c4cdb8bb1a3cfb2fccc95259"
  end

  depends_on "popt"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  # Backport upstream commit to fix crash with popt 1.19. Remove in the next release.
  # Ref: https://sourceforge.net/p/gptfdisk/code/ci/5d5e76d369a412bfb3d2cebb5fc0a7509cef878d/
  patch :DATA

  def install
    if OS.mac?
      inreplace "Makefile.mac" do |s|
        s.gsub! "/usr/local/Cellar/ncurses/6.2/lib/libncurses.dylib", "-L/usr/lib -lncurses"
        s.gsub! "-L/usr/local/lib $(LDLIBS) -lpopt", "-L#{Formula["popt"].opt_lib} $(LDLIBS) -lpopt"
      end

      system "make", "-f", "Makefile.mac"
    else
      %w[ncurses popt util-linux].each do |dep|
        ENV.append_to_cflags "-I#{Formula[dep].opt_include}"
        ENV.append "LDFLAGS", "-L#{Formula[dep].opt_lib}"
      end

      system "make", "-f", "Makefile"
    end

    %w[cgdisk fixparts gdisk sgdisk].each do |program|
      bin.install program
      man8.install "#{program}.8"
    end
  end

  test do
    system "dd", "if=/dev/zero", "of=test.dmg", "bs=1024k", "count=1"
    assert_match "completed successfully", shell_output("#{bin}/sgdisk -o test.dmg")
    assert_match "GUID", shell_output("#{bin}/sgdisk -p test.dmg")
    assert_match "Found valid GPT with protective MBR", shell_output("#{bin}/gdisk -l test.dmg")
  end
end

__END__
--- a/gptcl.cc
+++ b/gptcl.cc
@@ -155,7 +155,7 @@
    } // while

    // Assume first non-option argument is the device filename....
-   device = (char*) poptGetArg(poptCon);
+   device = strdup((char*) poptGetArg(poptCon));
    poptResetContext(poptCon);

    if (device != NULL) {
