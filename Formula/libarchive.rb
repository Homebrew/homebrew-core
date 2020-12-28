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
    sha256 "9982e27311b6299c9a47a291e00cf902612617459fc7f76cfada1f874e9e0473" => :big_sur
    sha256 "85dc5625295b720fb66f5f5bd3aef7b70f19cb3f486cfc4d828bfc308978027b" => :arm64_big_sur
    sha256 "81bddbc83606b2a67ad75591e8de48c208d3b261b04b92fc2ae009bb12da04fa" => :catalina
    sha256 "528c2e2a314abe3fce4d5b84f9792b01207bb9c5e2b401c91edcad698eef34ca" => :mojave
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
