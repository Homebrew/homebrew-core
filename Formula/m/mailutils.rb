class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.17.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.17.tar.gz"
  sha256 "403d0a8a7d923560ee189783a35cec517e9993dda985e35b7afd9c488bf6f149"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "b038dbc93f3690440b7c52e6731c143d9ef11365d2d6347cd3c7a862021caf16"
    sha256 arm64_sonoma:   "8a0c917dde78ad9e1e53adccfeed8a1ca7c5e465bf0fdae4392bb5460b407dc8"
    sha256 arm64_ventura:  "f2b9f4a8a2078da0008e291c8abe58f73ba89013277042fd1df9b2f72db43999"
    sha256 arm64_monterey: "8501f9f6b87427d70f99b03cd5246e6d22ebc9390c5a8211dcdf91166c209748"
    sha256 sonoma:         "beedafeac4b0ea238ab762c14445a2a546774e9b76a92bddbb998f2709069851"
    sha256 ventura:        "0298c5015f79f7f89bf550ab721f89b112b78df262cf5e789a125170e1836aa6"
    sha256 monterey:       "397d16b0b03abb041cdfe05afa402b2576922a41df4386f9c974708b700a42f3"
    sha256 x86_64_linux:   "9359d2d38ee56d75d796ed0a002b625eaaeece2e04248cc8a1493afbe9dba009"
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "readline"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # This is hardcoded to be owned by `root`, but we have no privileges on installation.
    inreplace buildpath.glob("dotlock/Makefile.*") do |s|
      s.gsub! "chown root:mail", "true"
      s.gsub! "chmod 2755", "chmod 755"
    end

    system "./configure", "--disable-mh",
                          "--disable-silent-rules",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"movemail", "--version"
  end
end
