class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.44.5/e2fsprogs-1.44.5.tar.gz"
  sha256 "2e211fae27ef74d5af4a4e40b10b8df7f87c655933bd171aab4889bfc4e6d1cc"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "0ef8e27e92e924346955f86ec8a0598983cd23226e49e929475989dc429d4916" => :mojave
    sha256 "9b82575ce0bb29f17f515bd64162b1ed979d53a52a2ad9f9031bd73ceb2dc633" => :high_sierra
    sha256 "658ec8e200559bc15381397eab5e4a2b54acc85a9cc6743949bc501855e9157e" => :sierra
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper",
                          "MKDIR_P=mkdir -p"

    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
