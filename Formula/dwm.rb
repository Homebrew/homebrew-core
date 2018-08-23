class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.1.tar.gz"
  sha256 "c2f6c56167f0acdbe3dc37cca9c1a19260c040f2d4800e3529a21ad7cce275fe"
  head "https://git.suckless.org/dwm", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "86302db90a0df481a5c2b58f73844fc78019ad4e9544a5f03c96369bc57523bc" => :mojave
    sha256 "6cc50618320a56720dd41717990c9cee08b2de731814b6b05275e9d6712cb80c" => :high_sierra
    sha256 "ab241356f8f38fb9e1ff6bba2dfbb07b8b82a5be0eee7fe75ba128548034115a" => :sierra
    sha256 "1f900b061eb8c36118c85c494aeb634da01d5dd7e3d6e58f9a1d8d5c53da2208" => :el_capitan
    sha256 "0e8c7d9f991b3269569e0d990dbf9fc56e89f9a6274a1abd72d41248253afca8" => :yosemite
  end

  depends_on :x11
  depends_on "dmenu" => :optional

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
