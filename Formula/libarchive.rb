class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.4.0.tar.gz"
  sha256 "8643d50ed40c759f5412a3af4e353cffbce4fdf3b5cf321cb72cacf06b2d825e"

  bottle do
    cellar :any
    sha256 "d3eb488c913723c85258a026d294af420fd6d502837ec340e0878ec5b7703c9a" => :catalina
    sha256 "83f56d2bc1d70ab3b8fcf6bf32780368c0dbfdf6c4e16d324f39a5cbac4ca4c4" => :mojave
    sha256 "62bb5281530d97f33a502a865d6178fe4d66d94323e468d8711d24cf834c7dd7" => :high_sierra
    sha256 "4e41f900e82a342b90721e09831397684e98222213d02e78694574758f9ce393" => :sierra
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
