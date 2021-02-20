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
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "70d00c2b7edaa2e7e84d8831edddfc07490f19016f7899bcde581d5d71040d67"
    sha256 cellar: :any, big_sur:       "88826e185e60eba60ad004889a76dae4354a15533a5ba8254ecf0323075b34cd"
    sha256 cellar: :any, catalina:      "616792d4660cc153ce5868fd612980af9b8b9e18d54c4199eb11e08bc9bb45da"
    sha256 cellar: :any, mojave:        "b231516d40d35180e1f61a50175324e4ce28f71aec27769ecc4661dbe6e883d0"
  end

  keg_only :provided_by_macos

  depends_on "libb2"
  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    conflicts_with "cpio", because: "both install `cpio` binaries"
    conflicts_with "gnu-tar", because: "both install `tar` binaries"
  end

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
    assert_match "test", shell_output("#{bin}/bsdtar -xOzf test.tar.gz")
  end
end
