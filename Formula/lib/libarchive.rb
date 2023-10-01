class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.2.tar.xz"
  sha256 "04357661e6717b6941682cde02ad741ae4819c67a260593dfb2431861b251acb"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5dcd7bf0a4b9ed437b6e0c6b19f386f837e52c80a99478e0d68bd320b38dfc87"
    sha256 cellar: :any,                 arm64_ventura:  "732a8e07ffd6ea82672b2de1164f139cf5567c4a7b730ff30c01820452f49c33"
    sha256 cellar: :any,                 arm64_monterey: "1c2386f4b7fb039dd6bad86e90d6f248594317810e28690bda23cb58b4952d09"
    sha256 cellar: :any,                 arm64_big_sur:  "86aa150734eddd98d6fc5f3131ef78fb182d0019ffc3ee98a5f0167d4dc99233"
    sha256 cellar: :any,                 sonoma:         "d132c0e42cb00165bf4765cb8af3f0bf954ed30d28b73ce4cf9168921fddb303"
    sha256 cellar: :any,                 ventura:        "2d766707533c6f3cbc43bcd516fde051664f1c60043439ee9bb0905be2f96d5e"
    sha256 cellar: :any,                 monterey:       "375f3581f47fbdf94c1650edc123bd80c3569fee3669f6349bfbdeec52dd09bf"
    sha256 cellar: :any,                 big_sur:        "cab50dba89e41b7fef61db78b65c3b6352cfe39cb473cb6e1b33eb5e4f960a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e41d7e3e515e4b37715d68de96db99e8946f3be9306eb934cb8ddc166ba9de02"
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
