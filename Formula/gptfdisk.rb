class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.9/gptfdisk-1.0.9.tar.gz"
  sha256 "dafead2693faeb8e8b97832b23407f6ed5b3219bc1784f482dd855774e2d50c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a324c027ce6d6f41d464ba001961e0481180ce5d43eddfebcec2c108358479cd"
    sha256 cellar: :any,                 arm64_big_sur:  "6ba98737562bd6ca00091e4259fa8195592e0d6f25b9650f8451f3cae553d6f9"
    sha256 cellar: :any,                 monterey:       "1d114b23a2a5cd0bbeb5b52bf9eb049a38f1ddd41b53abdfaf245b2ff333ae51"
    sha256 cellar: :any,                 big_sur:        "0e9d348490a0610c6342d624dafc745a838e33d3cf64287985470c79ac95e5a4"
    sha256 cellar: :any,                 catalina:       "ac261cf0e7e1b9848f4c2d9ce7cb85854eb10392d332018333330df0ebd6ba49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42a4448e83c5f84f9f947f9aef03bd1a67dffd95cea7edeb28bc1eae07c7be0"
  end

  depends_on "popt"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

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
