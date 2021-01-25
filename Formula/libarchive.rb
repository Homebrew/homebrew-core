class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.5.1.tar.xz"
  sha256 "0e17d3a8d0b206018693b27f08029b598f6ef03600c2b5d10c94ce58692e299b"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://libarchive.org/downloads/"
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "1c23bc3fa56221b24bf500672f2f2934cf3d5846d7a3dabda169f424955344a9" => :big_sur
    sha256 "a7fde93723f788e76cdfaf0efbfdea736d7046306d72c558b2fec1596be7d584" => :arm64_big_sur
    sha256 "7af1a019eb165fd3ca3ba1e6b09f2d1b44dc99d14a5d5b148462a8cd6b1d73b6" => :catalina
    sha256 "b0bd53d1118459d5acdc4a22c77ba5d273cb8249b5cdbbaf2800d633debfa415" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
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
