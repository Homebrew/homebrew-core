class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.3.tar.gz"
  sha256 "badaa028529b1fba1fd7f9a84f3b64f31190466c858011b53e2f7b70c6a3078d"
  license "MIT"
  head "https://git.suckless.org/dwm", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2229c9fa0e2b34b02d6ceb6529b655e5100e6c96f3684fe9ba106908a1e59d81"
    sha256 cellar: :any,                 arm64_big_sur:  "9544c01783dbd47a049adc2f1ae4269f79aa0a1ca0272e94414589d4acb9ca39"
    sha256 cellar: :any,                 monterey:       "fed2ddf1b8509e7ecb5f236432ac23a5b2c843fc7ec84b16c7f0aa220a5cd59f"
    sha256 cellar: :any,                 big_sur:        "96c4b987f4d8173368692428bd362c76ece48d34b267bb3040cb1fbac4406dab"
    sha256 cellar: :any,                 catalina:       "513bb01c5c1276e7606edb577504b101240c1245558ab30fe724be6b9d7c2dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3458070c89d4f324a82eb95651c456a1ccdc51bcac7df5bbe5ba305f02d72c"
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
