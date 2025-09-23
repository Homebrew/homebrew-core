class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftpmirror.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  sha256 "d10ee65ba391d6463952d8a81551f8a6e667538ee8587b3c801137e657087d4c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "6226a3e8389ad9ce81ec1b43a07196b2ad6469e16b58402d106748a191b30754"
    sha256 arm64_sequoia: "26c6cce1516f6ea2435473db754bc8f5d1df5cfa993dae465acb5926d53f2a0f"
    sha256 arm64_sonoma:  "a7febc3f8b9ce9a2ec7ac88c9a4b0663c0706fd51154fd0aba8ea1c04a95818f"
    sha256 arm64_ventura: "5ef7a611f4898010e32d274502f86702ee4d7415cb41bc8559c616ad0f31f9b8"
    sha256 sonoma:        "33ca8ab67fe35819016e0f7c076772d7052568d1c877e50d4b0bba65303bad18"
    sha256 ventura:       "5c677c2ff86e822d323ef6d29c48cfd77688cbab06ae587a1320dc72d8fec0ff"
    sha256 arm64_linux:   "d915542a1a5b9461b4c6762c4c5177f32a5e23a2282818cbe5702ba5d1b97415"
    sha256 x86_64_linux:  "f648b8567f2893c9ccc33e418da53ea7d93c50c8fe434f28d8694055019423a2"
  end

  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "python"

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
