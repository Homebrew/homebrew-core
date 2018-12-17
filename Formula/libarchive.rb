class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.3.3.tar.gz"
  sha256 "ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e"

  bottle do
    cellar :any
    sha256 "382799f81cebbdd3b22a681cfc5f5d2ada51db5025d4bdd9454a3c59c404a78a" => :mojave
    sha256 "8848eb337cc9646fb2499539175b664cc00680d0e5897fa0fe1b137091f4c16c" => :high_sierra
    sha256 "7aa83e866dbdc3b92443b24c684e0392fbee5542246156822718e08331419235" => :sierra
    sha256 "6cf2c9dda85ef5ec4f312c509c8843c30fedde748282886be4a2b88b0e877788" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "xz"

  def install
    system "./configure",
           "--prefix=#{prefix}",
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

    system "make", "install"

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
