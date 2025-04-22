class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.5.tar.gz"
  sha256 "21d79ebfa9f2fb93141836c2666cb81f4784c69d64e7f1b2352f9b970ba09729"
  license "MIT"
  head "https://git.suckless.org/dwm", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1aea6c7c3cc131887b7d471659137384ac7e415dd9fbe7d15e3d8ae9c6dbe180"
    sha256 cellar: :any,                 arm64_sonoma:  "922787e07a3be0599f223d64f413f62ca8b7bb2a6d6fefec4565a7357c359564"
    sha256 cellar: :any,                 arm64_ventura: "b7971ddb4bf6f52bfc8a844ff6ea0681a0c9d6645cea923b0851e94771068785"
    sha256 cellar: :any,                 sonoma:        "ddc7a7f3fbae58d7c4e8924ef3f53cff4906ac384f91a039bca5bdf097eb60d8"
    sha256 cellar: :any,                 ventura:       "bb5ad3a4079c76769e85ebda55ad12a1260e946be09c5b611bdbfdff3146fdf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a957940e9c5bbaf9b6ff415122794094c5384d24265b13772d1886dc46be1144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107dc6ce40aaa02fca9690bd3a7ac7804664cbfc49776b76354beccc8ba6da10"
  end

  depends_on "dmenu"
  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    if OS.mac?
      # The dwm default quit keybinding Mod1-Shift-q collides with
      # the Mac OS X Log Out shortcut in the Apple menu.
      inreplace "config.def.h",
      "{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },",
      "{ MODKEY|ControlMask,           XK_q,      quit,           {0} },"
      inreplace "dwm.1", '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    end
    system "make", "FREETYPEINC=#{Formula["freetype2"].opt_include}/freetype2", "PREFIX=#{prefix}", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        In order to use the Mac OS X command key for dwm commands,
        change the X11 keyboard modifier map using xmodmap (1).

        e.g. by running the following command from $HOME/.xinitrc
        xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

        See also https://gist.github.com/311377 for a handful of tips and tricks
        for running dwm on Mac OS X.
      EOS
    end
  end

  test do
    assert_match "dwm: cannot open display", shell_output("DISPLAY= #{bin}/dwm 2>&1", 1)
    assert_match "dwm-#{version}", shell_output("DISPLAY= #{bin}/dwm -v 2>&1", 1)
  end
end
