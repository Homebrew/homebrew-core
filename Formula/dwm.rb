class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.2.tar.gz"
  sha256 "97902e2e007aaeaa3c6e3bed1f81785b817b7413947f1db1d3b62b8da4cd110e"
  revision 1
  head "https://git.suckless.org/dwm", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "daf214e1176326bb756c9cd0af9bb48b00e06828247b524fae662bf9a7b601af" => :mojave
    sha256 "c6bd9f78eddcd7e02889f429364a08c0293d57b0c06246e021d102747c193ab2" => :high_sierra
    sha256 "4f9e0554b3b3f77c0e9fb3da05812e3424625ad63b271ef322f407027f4ac73b" => :sierra
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
