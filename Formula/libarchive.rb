class Libarchive < Formula
  desc "Multi-format archive and compression library"
  homepage "https://www.libarchive.org"
  url "https://www.libarchive.org/downloads/libarchive-3.6.2.tar.xz"
  sha256 "9e2c1b80d5fbe59b61308fdfab6c79b5021d7ff4ff2489fb12daf0a96a83551d"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libarchive[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8aa6a214d4ea80cb0092010bbfdd91aa6405c22b39a0587a5368c08dee6bdd15"
    sha256 cellar: :any,                 arm64_monterey: "3dca2b28193205841b537cb73c20dbe4dc19e473068196c0815c1c2dbf1cd9c0"
    sha256 cellar: :any,                 arm64_big_sur:  "255b8c7c939162611f4f7e7056555a19fd78459f642d224c28d4349ef8b804ff"
    sha256 cellar: :any,                 ventura:        "bc3d258c66c8ac7a30925dc823acc0f5d65bbe72b44396785a388b4f578780ef"
    sha256 cellar: :any,                 monterey:       "ca5dbd790a973e3f1b5d34fd8acdb7e7b1cab5d1557025939e72bad1646ab843"
    sha256 cellar: :any,                 big_sur:        "994462e0b0807311e1825879e20a951c55b61e0445b73b843bc0c55d4570a2de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf97322be50a6d08a28a1fc6838d50ca6da0e6234a87615325580a3f3784af4a"
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
    inreplace lib/"pkgconfig/libarchive.pc", "Libs.private: ", "Libs.private: -liconv " if OS.mac?
    inreplace lib/"pkgconfig/libarchive.pc", "Requires.private: iconv", ""
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
