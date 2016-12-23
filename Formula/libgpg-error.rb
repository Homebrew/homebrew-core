class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.25.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libg/libgpg-error/libgpg-error_1.25.orig.tar.bz2"
  sha256 "f628f75843433b38b05af248121beb7db5bd54bb2106f384edac39934261320c"

  bottle do
    cellar :any
    sha256 "72b4ba066c36701a6f3eaeca581faf0e4ed971ae97bd71dc345effb69575bfe6" => :sierra
    sha256 "31afa3a5eaae9962bd89cd9d65170e6c0308e1b58a3ace70f4433a53d795d50e" => :el_capitan
    sha256 "98a847a644ebc419ab2d66ce7ede10cb524fbff0b98898039e351fcea9f005ca" => :yosemite
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
