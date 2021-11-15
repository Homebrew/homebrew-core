class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.8/gptfdisk-1.0.8.tar.gz"
  sha256 "95d19856f004dabc4b8c342b2612e8d0a9eebdd52004297188369f152e9dc6df"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d9febc1bf30f45aad2e707d98a4f8485e4b8807787e39b92acacf0ba810c623"
    sha256 cellar: :any,                 arm64_big_sur:  "9ddfc62f39c786868b5bcafb0cc949a89977ece0bf27eac038a70dbcd7772b8f"
    sha256 cellar: :any,                 monterey:       "de52e1458baca0f7ece2e92f94031dc01197c4c109dc9b701367fd55aa163f0d"
    sha256 cellar: :any,                 big_sur:        "a16cd2748dcf4ce4a18caf1d09e04e077a456fe323553685ab07dc7b628567a7"
    sha256 cellar: :any,                 catalina:       "e5c8a8a789a75e2ff5cd3120922c0fa205ef3e9aec23fd77558a04b349283aea"
    sha256 cellar: :any,                 mojave:         "8ea2978e8d5612e21cef00d747ac24e0c5f44eeb5c9c2edcf926752bd389523a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93c2383a78abc4ea044c1d750630342118f7257358421c04471efd94c32cbce"
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
        s.gsub! "-L/usr/local/lib -lpopt", "-L#{Formula["popt"].opt_lib} -lpopt"
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
