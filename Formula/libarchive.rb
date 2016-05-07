class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "http://www.libarchive.org/downloads/libarchive-3.2.0.tar.gz"
  mirror "https://github.com/libarchive/libarchive/archive/v3.2.0.tar.gz"
  sha256 "7bce45fd71ff01dc20d19edd78322d4965583d81b8bed8e26cacb65d6f5baa87"

  bottle do
    cellar :any
    revision 1
    sha256 "a73405a0d1395f88af0999215bb0cc342b09113f6270375c7b9fe0bbad870c57" => :el_capitan
    sha256 "daf4fb57f9b01c4a0d3ac33ec5fcc59e133ce3b08e01caa6ffaa2e098ae1adad" => :yosemite
    sha256 "2f640bcaaa7ea8f090b9d163bb0cabba69e3efb62ec5ca5547ccfc5980935f9e" => :mavericks
    sha256 "a0da458477e1e080db4c7dc75326dd28fc40b2d9ba158d39089c079de4fefbdf" => :mountain_lion
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
