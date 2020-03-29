class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.4.2.tar.xz"
  sha256 "d8e10494b4d3a15ae9d67a130d3ab869200cfd60b2ab533b391b0a0d5500ada1"
  revision 1

  bottle do
    cellar :any
    sha256 "fea6de0e1c64faa83966a1bb23dc15275766940d9d25057bfd2d5bb9993792f3" => :catalina
    sha256 "ba1e2a44af82b21ad9ddcc906bb9b6f0073797b79a1a2d41758d253609c95628" => :mojave
    sha256 "b881cb42a16895795baea1137e3313de8ed632d8db241e0e4d2c361fbc5fc8bd" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "iconv"
  uses_from_macos "zlib"

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
