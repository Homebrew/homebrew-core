class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftpmirror.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mailutils/mailutils-3.20.tar.gz"
  sha256 "d10ee65ba391d6463952d8a81551f8a6e667538ee8587b3c801137e657087d4c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3ae52cae191219da35d841df60f919cd66d7a5cdabcfed6e8de2f20555926038"
    sha256 arm64_sequoia: "8d9b031ee3adcf94f41e0c4dda3f1877f334e357295ac65f80d61ca54ec8f220"
    sha256 arm64_sonoma:  "ec1f00fa1a4169d4ad5a5eff18532916d7e6606edd13f2ab1515a3573c04d510"
    sha256 sonoma:        "c8955a3e02a5ed11425f4ba397ab0ecdcb223c8097da184e3c6adffe2e43284a"
    sha256 arm64_linux:   "28649f27d729c35f82b1aa948c8c3bf228396b81336147a992565eb62ee44ec3"
    sha256 x86_64_linux:  "53a84459cde0d2bb37a9e97a0bef949666d2b4ab940eb8474467a185a83c8c43"
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
