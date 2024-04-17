class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.3.tar.xz"
  sha256 "63e7a7174638fc7d6b79b4c8b0ad954e0f4f45abe7239c1ecb200232aa9a43d2"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "15b2215adf583472857d72bbe93fba8bf6b1114952b9d2c271087726e6cff88e"
    sha256 cellar: :any,                 arm64_ventura:  "421d2bde9d01b19059035d335c27b5c6479891a1573ccfa3b2f996a21a9c455e"
    sha256 cellar: :any,                 arm64_monterey: "71bbd3c22e66416d1d54b009f8fd1d2e266e0c46cb4c7db21b386d7108e70a78"
    sha256 cellar: :any,                 sonoma:         "9d9f628769a7cee4ed6d761a77188f21a4b104cef6c050085dbf5a69ecddbf59"
    sha256 cellar: :any,                 ventura:        "520314360c9b052413aa0c192a16be35d1c1ef54bcf93608b30d8f016c8d0b3a"
    sha256 cellar: :any,                 monterey:       "2c80fed413a792f9a1c1a7aa8c68b0ab3dda72e6d83e55d57d4ccb15a6aa82c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6911d06fe561bb6965fcfbdadf34f77c47ddd5007ec71ade6f5d32c6363353a0"
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
