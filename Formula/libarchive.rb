class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "http://www.libarchive.org"
  url "http://www.libarchive.org/downloads/libarchive-3.3.0.tar.gz"
  sha256 "f9c80dece299c04dd5f601b523f6518ad90fef1575db9b278e81616cc860e20c"

  bottle do
    cellar :any
    sha256 "3903b25c80d2654fcaa6133064622a911dcd87aa8c14414fb87e32d412bbfd36" => :sierra
    sha256 "9f9daba158d0249cc6208421fde53f9c66c6c4c18992f8bf5eb5a932feb146b1" => :el_capitan
    sha256 "3f9b96060ed43436e38a07cf09772deed133da1ce886e3e71043dd41daa171a5" => :yosemite
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
