class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.7.tar.gz"
  sha256 "91ffbaa148bf63e965b21eb94597edbba53431c19f5061874e04ef3c58c1f192"
  license "MIT"
  head "https://git.suckless.org/dwm/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb7401dfd0524539c062b1d39b53b478ce8c194215404e83d6ba02fa31c0f830"
    sha256 cellar: :any,                 arm64_sequoia: "652c6fcfe1bd90255cf18acecbad3a66ba14d945c4d6588b7d1439883297d92b"
    sha256 cellar: :any,                 arm64_sonoma:  "d204902f42dbd6ea6d15c574970f0ff23d2cd1da9f995f329626db046b3cc4ac"
    sha256 cellar: :any,                 sonoma:        "f23ab8c5686104d50484cb737ac312a149fb477257495be3f99ca7919fdcff12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0280054fcf5e1aadd0d3dfda7ee279ee7d0da10e173acd397f4c5328deaaaadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708e8cf4e8da730da44a2bcbde8566acf3d47188b39b41ba022a86c183d657f7"
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
