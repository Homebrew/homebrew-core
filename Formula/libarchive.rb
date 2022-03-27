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
    sha256 cellar: :any,                 arm64_monterey: "bd4bba7609bee46526cbb9b98bfa0698ba1c041a38c8710c13a25d47ecf1bb1e"
    sha256 cellar: :any,                 arm64_big_sur:  "aaba8a09636886ed548f832564390f2bc7a9e821a267d0a6fcf92eeccd8bb81a"
    sha256 cellar: :any,                 monterey:       "f80ae675c50a74d98f3c9e72d652385f1701f473d9131943f703f51394625264"
    sha256 cellar: :any,                 big_sur:        "f8a134adf29066058aca3228a1130572631cc880916722a062b656977324ee2e"
    sha256 cellar: :any,                 catalina:       "dc262f8e48b08123ea561f3d2fd396490c47aa7ecc34b8dda2cef1f1cd177b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b7dfed62a80a9bc40e3dd38c5e171cb72aee1ad08a15a9fcbe28b3175e98aae"
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
