class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.10/gptfdisk-1.0.10.tar.gz"
  sha256 "2abed61bc6d2b9ec498973c0440b8b804b7a72d7144069b5a9209b2ad693a282"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "54e5ae58037ac6fac2b63fd42b7f477699b2c42fb1b38d050950de551d670c76"
    sha256 cellar: :any,                 arm64_sequoia:  "ba4643273f140cbd13365868699724cf632eb57dd3e5557d416437f84462b0c1"
    sha256 cellar: :any,                 arm64_sonoma:   "09a2999c7d63ed2b2b1d1653b8b0eefc58e6a34f44deea18621b8c0137fc3382"
    sha256 cellar: :any,                 arm64_ventura:  "f3950162cf89ae6ea39989311535d838e8c2d7989ccddadcfcafd90733056c14"
    sha256 cellar: :any,                 arm64_monterey: "51ac0f2d9d070772afbe428ea9ed3dc424e2b9b9eea017d78cc43c62d5ed9836"
    sha256 cellar: :any,                 sonoma:         "0f866a7fa08045f6cb0ccec6da7daa2f97f6160f3d1cbbfda57e3f5efa3f1547"
    sha256 cellar: :any,                 ventura:        "a991ae67bc6d77886ba9fdcac791531c8557d093e385c74d34c5252e8ac62039"
    sha256 cellar: :any,                 monterey:       "8b3365f6c8abda6ce8a8a4ee7b0fc0d7760cb69002b8710cef9c35413dfbdee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4fa3e95ed08561ff4010db7de68898854716dfacfd248bf1a4263aec35dc484e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c7afa4c318fb486bcaa3dec28ca8a349fd98135d68435f69ec56917fb9d2ff"
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
