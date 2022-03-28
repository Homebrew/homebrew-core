class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.6.0.tar.xz"
  sha256 "df283917799cb88659a5b33c0a598f04352d61936abcd8a48fe7b64e74950de7"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54bd0cfb0847f35990507648974084966866566a38b8acee649ee2a6481bd566"
    sha256 cellar: :any,                 arm64_big_sur:  "839dd824c6943ed6ef4e593762563e619abf105d9b09693f100e6748fd1d44cf"
    sha256 cellar: :any,                 monterey:       "b51d802d4af60858d2d3259f59552a275291137f8d7916011fbb2c24d4a152af"
    sha256 cellar: :any,                 big_sur:        "3c340236b3b61281ca13015331428aac177b8e90a139f2e1d786b63ee693bc24"
    sha256 cellar: :any,                 catalina:       "30b3839d8b57d2c06c2364565409f9a3546abd114641c23fecfd3967682029d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b60cb71bfd0f562574efeeafb4d79fa3e456672df83371f1f493b65477a6e37"
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
