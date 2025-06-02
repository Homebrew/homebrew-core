class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.0.tar.xz"
  sha256 "67bfac3798a778143f4b1cadcdb3792b4269486f8e1b70ca5c0ee5841398bfdf"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe6405c6a9fcf8cd6b54661a80fddef21958907a4b52f5ebd69c33f9fa29b8f3"
    sha256 cellar: :any,                 arm64_sonoma:  "40f5e09148764f47492d81fe3b9b968b920cf969cd153a5a69fcb324db9ee27e"
    sha256 cellar: :any,                 arm64_ventura: "4a2c92b6220099bc997e5b7629645750453c8a86738ee40448331cfec62a2ec6"
    sha256 cellar: :any,                 sonoma:        "e5361f147cb17b7bbe555c5825fb1583e4f3bfd844d6af6eae39e82ab3b68b26"
    sha256 cellar: :any,                 ventura:       "61f6ea5ae321cf669afc860bec2ef28c541b806465e945ec8280fdced3c5e994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e64fbf741da3b4f3450a84870220d873ca680da94707395e74dc496d9bf858a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3309a6a522da61f7d39cbfa417c643904a850fbb888c96e43264e4121a7baafb"
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
