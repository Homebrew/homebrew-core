class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.7.6.tar.xz"
  sha256 "0a2efdcb185da2eb1e7cd8421434cb9a6119f72417a13335cca378d476fd3ba0"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9da40802a9cc37b5a3a911c9092cf54761713ab47b31e5426235875783cfe54"
    sha256 cellar: :any,                 arm64_sonoma:  "6c846b324fa5b65f17e9c418b796465b4554eec304be753d9f5c7baf6d75dd8e"
    sha256 cellar: :any,                 arm64_ventura: "093f8b3668558e8158e6e4d05f606479ede1a852976dfbe88f8ffbb6da767c8a"
    sha256 cellar: :any,                 sonoma:        "22fd78b4a26ef9d81efa756ced732982ee0c8d4fd9f3c9e8a0164923198e4836"
    sha256 cellar: :any,                 ventura:       "0035c5b5a78ce22643b76b0499107a845f753754cdaa9ea15646aef0941f83f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b961068fd3e3f897e3332a2e97ebe3deafef4cb295fdd369d821106ba3e9ce98"
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

    # fixes https://github.com/libarchive/libarchive/issues/1819
    inreplace lib/"pkgconfig/libarchive.pc" do |s|
      s.gsub! "Libs.private: ", "Libs.private: -liconv "
      s.gsub! "Requires.private: iconv", ""
    end

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
