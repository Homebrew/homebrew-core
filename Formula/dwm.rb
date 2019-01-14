class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.1.tar.gz"
  sha256 "c2f6c56167f0acdbe3dc37cca9c1a19260c040f2d4800e3529a21ad7cce275fe"
  revision 1
  head "https://git.suckless.org/dwm", :using => :git

  bottle do
    cellar :any
    sha256 "96b24743e0a1e80f183fb9a9a6ba413c1feb78dc88bf7cf5fa5767a427bc24aa" => :mojave
    sha256 "3f38007bc1083269deb427a95e932e9474d7ff095406e3738944b3ae2d440a8d" => :high_sierra
    sha256 "ad026318ad2c198f997d2ffbf9724521d8ef766889a936f8ff9c4dbab8dafaf3" => :sierra
  end

  depends_on "dmenu"
  depends_on :x11

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with
    # the Mac OS X Log Out shortcut in the Apple menu.
    inreplace "config.def.h",
    "{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },",
    "{ MODKEY|ControlMask,           XK_q,      quit,           {0} },"
    inreplace "dwm.1", '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<~EOS
    In order to use the Mac OS X command key for dwm commands,
    change the X11 keyboard modifier map using xmodmap (1).

    e.g. by running the following command from $HOME/.xinitrc
    xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

    See also https://gist.github.com/311377 for a handful of tips and tricks
    for running dwm on Mac OS X.
  EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dwm -v 2>&1", 1)
  end
end
