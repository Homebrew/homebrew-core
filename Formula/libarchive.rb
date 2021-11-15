class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.5.2.tar.xz"
  sha256 "f0b19ff39c3c9a5898a219497ababbadab99d8178acc980155c7e1271089b5a0"
  license "BSD-2-Clause"

  livecheck do
    url "https://libarchive.org/downloads/"
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "909e772216b15d9a0d12bda588f49d79e4dd470f3fbaaa316ef2041c3ae20ebd"
    sha256 cellar: :any,                 arm64_big_sur:  "54ce08391c24b94f6a78380dcaa9829eb3c10b1cf7f9681fa51325034fc5e4a6"
    sha256 cellar: :any,                 monterey:       "38e84e45290ef05a5005b859548c92e4a6607b72127890834e47b258b4b073ea"
    sha256 cellar: :any,                 big_sur:        "465c65961a4bb3b17ad6c59ccc3077bf38ef7b3d862bd1d6b4cc4c08a9fdb086"
    sha256 cellar: :any,                 catalina:       "b6a3b5424cfc25a2514c35988aaa4b1e274105cfeae3f6083ed5864a85c87b6e"
    sha256 cellar: :any,                 mojave:         "6f5a155af0e351635e4f547c39b8a1a9aea845e043bc996f908b4b10b3385ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2628745c8bcf953cecd72ac4b7e0b9a1c3e7136525039aa6c91ee4535fd3cbf4"
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
