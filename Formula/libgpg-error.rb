class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.34.tar.bz2"
  sha256 "0680799dee71b86b2f435efb825391eb040ce2704b057f6bd3dcc47fbc398c81"

  bottle do
    sha256 "c6a6405ecb74bbc7d296b791a8398e91d213e1ce6f67df0d3b61481ed8bac377" => :mojave
    sha256 "21de798829b5f774b28100d3ab139f1a0d4e9c2d1235c4fc631e83ece1190cab" => :high_sierra
    sha256 "6df062fa53c63231b88d8b8b89d7e0f54a16039d621679c7e90bb1b273834a3c" => :sierra
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
