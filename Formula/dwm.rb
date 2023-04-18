class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.4.tar.gz"
  sha256 "fa9c0d69a584485076cfc18809fd705e5c2080dafb13d5e729a3646ca7703a6e"
  license "MIT"
  head "https://git.suckless.org/dwm", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ea89386f0283643f4034d9223c9c5cd39172b630ddf3046769a8655537f3ea4"
    sha256 cellar: :any,                 arm64_monterey: "10e4acc8a0acf14b00397ddca12a3324e5cbf2ac881974472e473fe4a555b783"
    sha256 cellar: :any,                 arm64_big_sur:  "45a4e170d418e0c7caeace0c4ddea6e8986b53e59906f056b95f42aa2d4201fe"
    sha256 cellar: :any,                 ventura:        "da198c90c358db49b0d9827f1b9702099fb7e7d5b9f74d4fb5caba0a89a1a651"
    sha256 cellar: :any,                 monterey:       "9774dc44a72ebf8831d07261e49d5607036b03895af484091828452fed9e09b2"
    sha256 cellar: :any,                 big_sur:        "1620a1e55c9bbce30c5c0247bd02425120fb317e39c5a97ff34ea163641b388d"
    sha256 cellar: :any,                 catalina:       "0632b1fa0115e7f403e2cd6e05ad4df2554dabc1018825eb16976798b1a84e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c0fe1f422ba854396d792b3fe28225f5658edca9e0fd98cadff55eeb8b0f13"
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
