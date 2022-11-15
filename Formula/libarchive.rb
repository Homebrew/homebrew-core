class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.6.1.tar.xz"
  sha256 "5a411aceb978f43e626f0c2d1812ddd8807b645ed892453acabd532376c148e6"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e998ea917d0ca7ddd938af2a0e0270e4a28240170e66dd07d32e8276bf3bd3a2"
    sha256 cellar: :any,                 arm64_monterey: "0cf4a68e9bd6d24a4579bdf08eb33348151464d525e279f569f0b51e60ccc2cd"
    sha256 cellar: :any,                 arm64_big_sur:  "305f6be2e4fe73076a065ac7ebf82158d13e702ef8cfa8be1494a9f29ed1dd19"
    sha256 cellar: :any,                 ventura:        "f58410e4c5c73f86a27a320f030801789b920beb36ed73011442f9995fa6c077"
    sha256 cellar: :any,                 monterey:       "652e949db4255c0dca6feee1a8cc96361a66458f4439c58a7dfd0c8215840b80"
    sha256 cellar: :any,                 big_sur:        "a241d5e65955c8fcbbebac59b8eb85fb2949131d89352adced58929b5cd9b755"
    sha256 cellar: :any,                 catalina:       "9d6b54ed2a65936461827076e3e1e8addb96d06ca2ff318e8fe0d89f144146da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e1bfdebe427e1ccb2816a1e393aef985d2d2e6530d96dc166e1914c5c10b59d"
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
