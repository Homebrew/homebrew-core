class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.23.tar.bz2"
  sha256 "7f0c7f65b98c4048f649bfeebfa4d4c1559707492962504592b985634c939eaa"

  bottle do
    cellar :any
    sha256 "a9abfd9015cc2338595dca8766ee9ab122be659ddf035e2cdbb6be08a9db22cf" => :el_capitan
    sha256 "e97149f2bee52603d4808f18ecc5db9611be06aa113d55df7a00a8ed2b6ff9c1" => :yosemite
    sha256 "75d5a84eddb2ad65367235cb6f8a51a9fed0966fe08780619a7031cbc3e6e5b2" => :mavericks
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
