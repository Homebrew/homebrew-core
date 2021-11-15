class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.2.tar.gz"
  sha256 "97902e2e007aaeaa3c6e3bed1f81785b817b7413947f1db1d3b62b8da4cd110e"
  license "MIT"
  revision 2
  head "https://git.suckless.org/dwm", using: :git

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3971098bdbc2dee1f4acac3020a38052d6be49f777543c422e93e2c2f361e3bf"
    sha256 cellar: :any, arm64_big_sur:  "7fd3a01a1f29927ca94c2c5ea32b4ee0c9f31d9ea39adc04e76ab40517663149"
    sha256 cellar: :any, monterey:       "ac0754547b75d1e161c9401e78dcad9c9560d76f45483c19fbd1890429b88cc7"
    sha256 cellar: :any, big_sur:        "afd787afd9c6ea4cc81c100f324d2b8aa4c65c2a06e43ca87d54135425b347cf"
    sha256 cellar: :any, catalina:       "d872be09d1f5c11c9fb4d34002cc5f4622fbc259691800e1742354573b9effb0"
    sha256 cellar: :any, mojave:         "e4ec85368754c0594847dad5272770a36e69876ed433fdd390d73a7d05c43263"
    sha256 cellar: :any, high_sierra:    "b22ec01678edc39f1b82837087bb69ac311bce937eb10cb096fc8b1002f97701"
  end

  depends_on "dmenu"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with
    # the Mac OS X Log Out shortcut in the Apple menu.
    inreplace "config.def.h",
    "{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },",
    "{ MODKEY|ControlMask,           XK_q,      quit,           {0} },"
    inreplace "dwm.1", '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make", "FREETYPEINC=#{Formula["freetype2"].opt_include}/freetype2", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      In order to use the Mac OS X command key for dwm commands,
      change the X11 keyboard modifier map using xmodmap (1).

      e.g. by running the following command from $HOME/.xinitrc
      xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

      See also https://gist.github.com/311377 for a handful of tips and tricks
      for running dwm on Mac OS X.
    EOS
  end

  test do
    assert_match "dwm: cannot open display", shell_output("DISPLAY= #{bin}/dwm 2>&1", 1)
    assert_match "dwm-#{version}", shell_output("DISPLAY= #{bin}/dwm -v 2>&1", 1)
  end
end
