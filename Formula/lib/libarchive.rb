class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.8.1.tar.xz"
  sha256 "19f917d42d530f98815ac824d90c7eaf648e9d9a50e4f309c812457ffa5496b5"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33b077565a53ca5ec7d802a3b86e38765f075cdcd3d63c43ba597b42ce2afcb8"
    sha256 cellar: :any,                 arm64_sonoma:  "2b14673ed741aa5fd8fd51d02a921b2101e36fded71e5a29cba9e6223cbac880"
    sha256 cellar: :any,                 arm64_ventura: "be0595be8e5f8c9bcab85247494bd5209c0e15f31f1a95c7e1d81ea1639f2609"
    sha256 cellar: :any,                 sonoma:        "e5b8299cc88814bb13fe64e97832392aa3c7b168749cd48cd4e38effac946591"
    sha256 cellar: :any,                 ventura:       "0d796b81038699e8f82625c44e828e3934f3a107cd21a604ee54f5c3a7da1f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b588849dd058493a566a94816f8a05e754dcd2be862edac87279158ad6b9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ad0aa42b5dcb7be104e4f5f6bd758b258bd4c46b49baac6c5e9e7f4a964a4e"
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
