class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.24.tar.bz2"
  sha256 "9268e1cc487de5e6e4460fca612a06e4f383072ac43ae90603e5e46783d3e540"

  bottle do
    cellar :any
    sha256 "7a4c9788944fcb3ba9f0a328bf14b403a415f3ad1aea5af2e60a18ae345af6c7" => :el_capitan
    sha256 "865a303e5077a387810478e31652dce730b686a5d53e626c2d5fd27cab8718fa" => :yosemite
    sha256 "45cf56d5baadbc9004971434b44ebf653fffeac80b4599d393f0afe220eb4648" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
