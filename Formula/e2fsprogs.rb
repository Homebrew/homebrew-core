class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.9/e2fsprogs-1.43.9.tar.gz"
  sha256 "5be0ffc01b9720a3f3ccfc86396016baf1334b98751fefa09e0c63eaffdc3897"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "d3d586958ff43cf2bbb58bfa47773585c1023931020001b942211fa57b51b3fc" => :high_sierra
    sha256 "57fcc0cb4cff5a0a29a0226615ca397ae56f1df46796d43f2b9155a56dbdfd96" => :sierra
    sha256 "cbfd5ec222f8d56ffdc13f9e42c85893a1e9b7621ec8e4b9f07bb9be7843812a" => :el_capitan
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
