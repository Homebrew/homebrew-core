class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.18.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.18.tar.gz"
  sha256 "91cc5fc52d6fadb481102ecfeefdd210a75975b0bd01577d9393fcc1ba4798e5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "753604bb987c55a0072a907509ffad8faa25fd35dfa72696b7797156770c4ef6"
    sha256 arm64_sonoma:  "d7c03458852b7b4522595ce8801b5a0cdeaf34ae76ef9e93300b96370f235bdc"
    sha256 arm64_ventura: "1480c514c7284b1229318368ab1e4a6e0075f3e4f320038b48c72faa11fc1b69"
    sha256 sonoma:        "63a50102b0c5ebbf5f9610f9040b33b432dabcdd23f6f2a207e591d00e036459"
    sha256 ventura:       "ecbfbc7b323e9e815f409f319edbd394b48caa9c2e79d6754e7489fd5dec3076"
    sha256 x86_64_linux:  "76e8d8e74906ee588371c9425cd5ba34d5a7d75e69bf6be04d9081f23dae7c14"
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
