class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  sha256 "7f0c7f65b98c4048f649bfeebfa4d4c1559707492962504592b985634c939eaa"

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
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
