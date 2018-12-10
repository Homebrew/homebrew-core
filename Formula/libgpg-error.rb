class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.33.tar.bz2"
  sha256 "5d38826656e746c936e7742d9cde072b50baa3c4c49daa168a56813612bf03ff"

  bottle do
    sha256 "fba8de71f2dd273a65e13f4f840c664c448443f14a88e3532c74f89ffa5d997f" => :mojave
    sha256 "2e6fd2335afa3af8ce25f337f80d38ba3447e5a054c729711e60b0d107b21bb7" => :high_sierra
    sha256 "32b74e2a574575de2bdbd26e55732169702de45f872a35790e371aa1fe15d4b0" => :sierra
    sha256 "5554d7a582da3a4e196bd688d083bf4fe385aab7754c6c7ebe0a033db29eed19" => :el_capitan
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
