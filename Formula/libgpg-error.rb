class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.33.tar.bz2"
  sha256 "5d38826656e746c936e7742d9cde072b50baa3c4c49daa168a56813612bf03ff"

  bottle do
    sha256 "6664e8572b086bb9d639187a6a5bf5091c99fae327f94c56924054ed71e2c692" => :mojave
    sha256 "49310f6cc3a363b2ac925f0e7b37fff8c11663b4294da1f4ae3cdeae10208fac" => :high_sierra
    sha256 "b5f5179c0ffa92a99aa922bd154164ce1c28356382b2206c5893c7b2aa4c3b32" => :sierra
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
