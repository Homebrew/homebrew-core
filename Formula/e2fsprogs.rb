class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.44.2/e2fsprogs-1.44.2.tar.gz"
  sha256 "e5c05a5ba4a9a1766f4b500ad7ef3220843860bfa64ebdda1b462b23bcb37f68"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "efb60f33aeebde065e3af6874bcabc10aa406cf07b592121d51315216457b6a3" => :high_sierra
    sha256 "112e0b076519130ab8b48cde0659574d85573f6c0682d4d2f75034aad9bb479e" => :sierra
    sha256 "095ad2a91bd6de38a4faa73cf27b00dce06ff611a9011c40db1b2b627e6720eb" => :el_capitan
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper"
    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
