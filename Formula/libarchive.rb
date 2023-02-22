class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.6.2.tar.xz"
  sha256 "9e2c1b80d5fbe59b61308fdfab6c79b5021d7ff4ff2489fb12daf0a96a83551d"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7875b099adf5d4e1849aad7cc821ef42eab778754ba9c4d8d120627e73dd526b"
    sha256 cellar: :any,                 arm64_monterey: "a50e5026469436a003651754a6a19355505c9431d0303136d19169e712d4fa7f"
    sha256 cellar: :any,                 arm64_big_sur:  "455f93f00649d131b31e3ac8d062ad1a7c1e9aeefc808bdd24c2b6063e35ba2b"
    sha256 cellar: :any,                 ventura:        "2be5517c185bbfd88f0d60836b209286c1315be3b4b31c3f1d5837a8ac0a5bbd"
    sha256 cellar: :any,                 monterey:       "dbb5277eefb301b4143d0ca0adfb6c579818824c66f8346d96b567bc917de97d"
    sha256 cellar: :any,                 big_sur:        "bd27460ed8639a1f552163cb09e6c5b8670eb133e6303f5ea0ac9be96bceb330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbff046632857e48d0146467dd298d1ed6b8315ceb405cc296b09410a6c7f1bb"
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
    inreplace lib/"pkgconfig/libarchive.pc", "Libs.private: ", "Libs.private: -liconv " if OS.mac?
    inreplace lib/"pkgconfig/libarchive.pc", "Requires.private: iconv", ""
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
