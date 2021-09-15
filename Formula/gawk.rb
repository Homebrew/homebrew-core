class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.1.0.tar.xz"
  sha256 "cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "9b31b5843e7f156d5af09afb14b9fdbe359ece800222c9fe3fe23a77621491a6"
    sha256 big_sur:       "8ff8108740004ede9c938b8bb42d2768d532d9ac8ee492250bbd23c8dfbef0cb"
    sha256 catalina:      "581b48f781104f0c3233edc30c47628f4eec8c2f1f2e191151f367ce26ec538a"
    sha256 mojave:        "ddbb56c56d66f375147769a27301e2ffd099abdc07f5dfc16389af22028e185b"
    sha256 high_sierra:   "eac1b8c97c682c32a1b6c589818aa8ffb8f09630258ed6f215c882368540713e"
    sha256 x86_64_linux:  "9dbdb614ce8517ce0d43f4058ea96bdc9ab172fbb2a60160c3963109f19b3d71"
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
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
