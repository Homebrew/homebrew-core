class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.4.tar.xz"
  sha256 "f887755c434a736a609cbd28d87ddbfbe9d6a3bb5b703c22c02f6af80a802735"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d97e0d2bf8558c7c09b84a48931a75b69e91635d876aee86d99ff2f2f1857ef6"
    sha256 cellar: :any,                 arm64_ventura:  "cd817acf144903029b3afcd77f71676cee79c8836709d31f53ef25b2416ca11e"
    sha256 cellar: :any,                 arm64_monterey: "2eee8e2a8945d77bea76a2640d1cb7206d6968a98bb9c3ee5dd1cd1d55f864a4"
    sha256 cellar: :any,                 sonoma:         "54b0d28b0b58e520aa821731d4273381bb2f876b074c2c5e5f805c8289f6be7d"
    sha256 cellar: :any,                 ventura:        "f79cb4e1998fd66e7c2e9da3aad7909386c6ddf46384d953f37454c99b4fd132"
    sha256 cellar: :any,                 monterey:       "fe413fdc80c20fba27c219558e969d67674379035790a5395f4c985e33dcdc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead64680a2a627e4443a898a653ba76c95dbbd099fbd1be5b3f6790f7571b6e1"
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
