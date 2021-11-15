class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.1.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.1.1.tar.xz"
  sha256 "d87629386e894bbea11a5e00515fc909dc9b7249529dad9e6a3a2c77085f7ea2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "093465f34b94ec8ddeb4ff8dab2a02dafbccf8ec05f6ef0391673b7c4fd0a91f"
    sha256 arm64_big_sur:  "efc88dd4e2c2d87eaddb7aed2487eb17128e056ce47ce117f234a287e0e7160e"
    sha256 monterey:       "2dcae063cbf93dd82b36be9d9aaf08644831a5f9efd304af768b3b59f7db5192"
    sha256 big_sur:        "f909760ee429b1b41478900af7245c57cffe0a31f76b651c86e08cd1b6bcbc4d"
    sha256 catalina:       "1bfbe650e0ef014e64d5380558c21a450aff7196f06596ff89484b185777dc90"
    sha256 x86_64_linux:   "e62547695b5737c52a3174813091354f5ef1ef6e1369401f5f72367278caf578"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  conflicts_with "awk",
    because: "both install an `awk` executable"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
