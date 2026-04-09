class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.8.tar.gz"
  sha256 "bcf540589ad174d4073f4efa658828411e2f5ba63196cfaf6b71363700f590b7"
  license "MIT"
  head "https://git.suckless.org/dwm/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c050c0dbe42f70660c8c8a839c1add0e2191813b34bd252edd46d5ee66382196"
    sha256 cellar: :any,                 arm64_sequoia: "26e6e97d8d3b35c23475c724fd821b9f39fc15bc304ee1b77026cc354fb30686"
    sha256 cellar: :any,                 arm64_sonoma:  "06b39839497a3a9e38eda2a515b53890736e0bb1e9c99d4b3db8b7db0efe840f"
    sha256 cellar: :any,                 sonoma:        "55f6b2bb74c496486752529209f6a08376368277f1882e76a8d6706eb78b092d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed6c19d7305ea1a748d5274cc7569268b6668cb01df68a9fb03a14329958ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f5ff55153d68b2c4ff9318e9a17bb973d1277cd87cf3019a43233d23890ef7"
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
