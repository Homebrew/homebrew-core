class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.3.tar.xz"
  sha256 "90e21f2b89f19391ce7b90f6e48ed9fde5394d23ad30ae256fb8236b38b99788"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7eac9a41323f6ac4bde2959448f10e6e4aa4a0b547938d03e257abf782af968b"
    sha256 cellar: :any,                 arm64_sequoia: "3b492145ba1e03fa263627db4916dbbd4b406c6d90b33f9023189eeefbb617fd"
    sha256 cellar: :any,                 arm64_sonoma:  "bdacff0621b63baa58dc81e8c626ace68c669811df320c68fae86631cb61243d"
    sha256 cellar: :any,                 sonoma:        "a4082af1aa8f88e4c37adadc2b66f3cbd61c732889f2eac6dda6c7ab97475a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e534ffaf59d2b264343f42d46d17548433453d041ab23807680d2a7580a40a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233d4885a1804084c427a1ae27bd571774a1fa4b6f97ea4fa7cf1c26f2badd7d"
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

    # Avoid hardcoding Cellar paths in dependents.
    inreplace lib/"pkgconfig/libarchive.pc", prefix.to_s, opt_prefix.to_s

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
