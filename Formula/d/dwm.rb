class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.6.tar.gz"
  sha256 "7cfc2c6d9386c07c49e2c906f209c18ba3364ce0b4872eae39f56efdb7fc00a3"
  license "MIT"
  head "https://git.suckless.org/dwm/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f54870201f722572b9dd08b71200bc041635209fdec7ec1ed35bf75d71cffe02"
    sha256 cellar: :any,                 arm64_sequoia: "6eeb362a8c4a091e32a4e9bbad14b3475f89360df494e35dfb028c0dcebe8624"
    sha256 cellar: :any,                 arm64_sonoma:  "94d791de879fd2634abb78108dc9cac02821a49eeb9051ac6650ecbf9e0d03e1"
    sha256 cellar: :any,                 arm64_ventura: "106704c41bfc3aa0de266096aab0afafca663735607f60618d8469ad0be950e2"
    sha256 cellar: :any,                 sonoma:        "41e6a95715296f82e4c90aedc01e24edd56422016c19add4a2c2f089b5980ca0"
    sha256 cellar: :any,                 ventura:       "1a8627175db294d799fe38c162aff94588530842ead319c02bb33f20a25b5b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c899def601035f7642aa2309b8b0206610d36875c18b52eb9db85ad27e0395c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b93278a8d7083fe2d9bf319d6ecac058e36c7477483697454a348a485c70b2"
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
