class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.37.tar.bz2"
  sha256 "b32d6ff72a73cf79797f7f2d039e95e9c6f92f0c1450215410840ab62aea9763"

  bottle do
    sha256 "36dbd30d1702f91f9197b0987587767838a118f3fd88f579303247b752b15740" => :catalina
    sha256 "a708445b7304f711ed41bbf95f5cc90e3c6c08339bb9e4d707b2a476971827d3" => :mojave
    sha256 "b17e8b8e93add16424efb34b5a9f6ab280b3127050c560db5829b4e16de7cabd" => :high_sierra
    sha256 "bba0dd545de4ce5469ba008009c04fcae21db32ae1cb755b7d57071741de3cfe" => :sierra
  end

  def install
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
