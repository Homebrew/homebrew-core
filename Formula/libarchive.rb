class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "http://www.libarchive.org/downloads/libarchive-3.2.1.tar.gz"
  sha256 "72ee1a4e3fd534525f13a0ba1aa7b05b203d186e0c6072a8a4738649d0b3cfd2"

  bottle do
    cellar :any
    sha256 "6ef9838a7fda2a6ffacf250a29a1ce5fb9a71072f6c02b134c464096d6514491" => :el_capitan
    sha256 "f79d996c549f190b3225dbef988824afdec92cdcd76e39faae3ac2e67731d34f" => :yosemite
    sha256 "a702d412a72902bfec4c7093673d9df7e7a6df819a73aa1ccec5f074685d30eb" => :mavericks
  end

  keg_only :provided_by_osx

  depends_on "xz" => :recommended
  depends_on "lz4" => :optional
  depends_on "lzop" => :optional

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
