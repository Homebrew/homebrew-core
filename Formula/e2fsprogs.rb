class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.44.2/e2fsprogs-1.44.2.tar.gz"
  sha256 "e5c05a5ba4a9a1766f4b500ad7ef3220843860bfa64ebdda1b462b23bcb37f68"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "85d5829a6e42d07b909db8341cc5c1cc38c2a1cd27f7cc3574195755e567a786" => :high_sierra
    sha256 "d9f38ed0f8507ae2604f36f1b84f2a22c520751171e27825645031210dc4bf8f" => :sierra
    sha256 "66728810bf56be3aed6fde9702cbccfd2e9d99cc34683c821d90762201abe693" => :el_capitan
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
