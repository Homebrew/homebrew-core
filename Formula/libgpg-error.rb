class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.35.tar.bz2"
  sha256 "cbd5ee62a8a8c88d48c158fff4fc9ead4132aacd1b4a56eb791f9f997d07e067"

  bottle do
    sha256 "1a96796605d2d7dc8a558848965a09678b13e50d52a971729bdf9a96b6f824c7" => :mojave
    sha256 "168ef933ffd337d5a7ead3417b3bedec4e09982de3ed067f1b7302022c7fec00" => :high_sierra
    sha256 "6566112d47fe7d6914158d530072d9feb1dae6262289ffb7eca4d16b54851d05" => :sierra
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
