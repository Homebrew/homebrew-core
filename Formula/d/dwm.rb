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
    sha256 cellar: :any,                 arm64_sonoma:   "42c934372742b8f035539bf79d2b8d0a7a22d9391329b1ce9aa1d6ce030ae410"
    sha256 cellar: :any,                 arm64_ventura:  "6bacb2762fae033de162a20665ca7695e7af99e739ca869563cb2503d546ef89"
    sha256 cellar: :any,                 arm64_monterey: "c9746655f8aec5b7da2106a02ba7e3851dc43e46536bcea2bb102c616ec4b1d8"
    sha256 cellar: :any,                 sonoma:         "bbd11ee191cfbd498a774fd08f57f6df864e020da44e9ecfb6abb1a57ed8669e"
    sha256 cellar: :any,                 ventura:        "c9d816f1f7133f785e6453df1d59d21743bf32bd11f9618d8c5882724a7e3a02"
    sha256 cellar: :any,                 monterey:       "aa0f35f0f7e181e1f6b8c0fa959f637e8919b04561072881721a14c2d31ef4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d9965667c723f02db24e1ea68f1f1a80c891115028a12f8934d921c9a112ac"
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
