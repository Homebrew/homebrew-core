class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.2/hunspell-1.7.2.tar.gz"
  sha256 "11ddfa39afe28c28539fe65fc4f1592d410c1e9b6dd7d8a91ca25d85e9ec65b8"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d8f2e9708570919c8e043e60ec23e98072be9f23e47924077c233fc7ed389fa3"
    sha256 cellar: :any,                 arm64_sequoia: "26f11affce6b4d0e653103c0b88f3ec6e16b357f2c171f0253c8553c62cbe255"
    sha256 cellar: :any,                 arm64_sonoma:  "7e63672012544da3b91997e8cc9e23975fa126e4c938b5ec7966dd260771c84a"
    sha256 cellar: :any,                 sonoma:        "fa7adc42070e6857705a43f4cf57b5999611c37de739b6706599d9da55bac05b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfa788550dae98243a9bb43ad1ae0e2cb5cd2d443bf02b01e0e4ac3412a8732c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42fdde6e88f4fec0bdf4c8fcb259bb2cff651aaeaca575faaa147d0f22a18239"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build

  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "freeling", because: "both install 'analyze' binary"

  skip_clean "share/hunspell"

  # Backport support for searching hunspell dictionaries in pkgshare
  patch do
    url "https://github.com/hunspell/hunspell/commit/874abbbe65e228df525023afe176b42df34a7a4f.patch?full_index=1"
    sha256 "b1b59cc11e720a047302b72ce1870712f29ca22f3023726c576ffd6f713d2841"
  end

  def install
    # Regenerate configure to use patch
    odie "Remove autoreconf and build dependencies!" if version > "1.7.2"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules",
                          "--with-ui",
                          "--with-readline",
                          *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"

    # Find dictionaries installed by other formulae
    share.install_symlink HOMEBREW_PREFIX/"share/hunspell"
  end

  def caveats
    <<~EOS
      Dictionary files (*.aff and *.dic) should be placed in
      ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
      provides no dictionaries for Hunspell, but you can download
      compatible dictionaries from other sources, such as
      https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
