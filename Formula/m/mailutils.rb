class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftpmirror.gnu.org/gnu/mailutils/mailutils-3.21.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.21.tar.gz"
  sha256 "5e305de7fcf2f744c8b210f1cfe904d49842bfc6d13a913031ec4dbf0c669c54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "3bbe34b5065fd6cdf2585b829869afb913e27310f5d9fc17e8ae0c9f55785ce5"
    sha256 arm64_sequoia: "31c47eda8f72d7d33763a5707b2d8f184471c6c7940ee426c490e6ab72738e7a"
    sha256 arm64_sonoma:  "0a24ba5ab2eac9531076315acc05549a3b921dbf334ed2624ac2e8dbc51d11af"
    sha256 sonoma:        "50f0023f1b027e9f6f6f8892f2d907421b210a8a2d0371d3f34c6bbc5ffb10af"
    sha256 arm64_linux:   "0489c463756a0cf78b6e696339ddb02f695e7ef75a7f002b5e761c7458711299"
    sha256 x86_64_linux:  "dca5b4e67b558d3641d13075ffb6f7af243d5599227702e2f3440b3e8409acb2"
  end

  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "readline"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  def install
    # This is hardcoded to be owned by `root`, but we have no privileges on installation.
    inreplace buildpath.glob("dotlock/Makefile.*") do |s|
      s.gsub! "chown root:mail", "true"
      s.gsub! "chmod 2755", "chmod 755"
    end

    system "./configure", "--disable-mh",
                          "--disable-python",
                          "--disable-silent-rules",
                          "--without-fribidi",
                          "--without-guile",
                          "--without-tokyocabinet",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"movemail", "--version"
  end
end
