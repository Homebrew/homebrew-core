class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.1.tar.xz"
  sha256 "b17403ce670ff18d8e06fea05a9ea9accf70678c88f1b9392a2e29b51127895f"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d7d9dddbbc96ef7c620ec4e366a91a68162b8525bc816cfd7e9c46c89bede5b"
    sha256 cellar: :any,                 arm64_monterey: "403720cd7dacae2a336ca4468cd99d945169de168e96640c90d5a0edf316884f"
    sha256 cellar: :any,                 arm64_big_sur:  "e1edf67677a95201614552089ed995ea20f224fce34da1a18ea8645e2874549c"
    sha256 cellar: :any,                 ventura:        "22e676223ed68dabbb8c22ed0c5c51e285736e8cc976366ae2a5da3fb0d7d055"
    sha256 cellar: :any,                 monterey:       "b36757beb7ec487e3dbe76c9e4ed5b32e0dab04c9f1c36ba5e1c7f44faf5dba4"
    sha256 cellar: :any,                 big_sur:        "cec7ea50eb8a73e0b067ff1fe4b2561e882e69954e3fc39dcd57d30a8672d033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a584a26875be96cf70679cd4a0484bd95c3c23e751dc24884e01adedaba131d3"
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
    system "./configure", *std_configure_args,
           "--without-lzo2",    # Use lzop binary instead of lzo2 due to GPL
           "--without-nettle",  # xar hashing option but GPLv3
           "--without-xml2",    # xar hashing option but tricky dependencies
           "--without-openssl", # mtree hashing now possible without OpenSSL
           "--with-expat"       # best xar hashing option

    system "make", "install"

    # fixes https://github.com/libarchive/libarchive/issues/1819
    if OS.mac?
      inreplace lib/"pkgconfig/libarchive.pc", "Libs.private: ", "Libs.private: -liconv "
      inreplace lib/"pkgconfig/libarchive.pc", "Requires.private: iconv", ""
    end

    return unless OS.mac?

    # Just as apple does it.
    ln_s bin/"bsdtar", bin/"tar"
    ln_s bin/"bsdcpio", bin/"cpio"
    ln_s man1/"bsdtar.1", man1/"tar.1"
    ln_s man1/"bsdcpio.1", man1/"cpio.1"
  end

  test do
    (testpath/"test").write("test")
    system bin/"bsdtar", "-czvf", "test.tar.gz", "test"
    assert_match "test", shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
