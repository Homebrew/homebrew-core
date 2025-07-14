class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.19.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.19.tar.gz"
  sha256 "aeb6d5fca9179da0402cf6adef36026f656d6ae6de4e7142c6b0a035161fd7dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "d790720aa6cb28ca860975492e83556a861c5ad47d4992096c09dc4583f44191"
    sha256 arm64_sonoma:  "02507fd28f0de0b0a4ede1239678aa3814611eb46b74e30f8c90c1db97c2629a"
    sha256 arm64_ventura: "fe58a7bd2bdb2ef56d042c1c80958c866883921354116018346712406a528bae"
    sha256 sonoma:        "fc9e4ba51f56ceafd83ea5717d64c5743eba692ec06d4f80362c908a3e7a2f5f"
    sha256 ventura:       "e7cf415dcd40794880d95390f3add8fec9525d205cc74ecd40ffc1fc812eb778"
    sha256 arm64_linux:   "c7dba705daf92061c4e674ddbcd8a84e0a500db7d1f5e3e52b2b7e2a05501388"
    sha256 x86_64_linux:  "8cf1753255aa8749c4669d1abdec367627998243decd6f8c72500068efb326c6"
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
