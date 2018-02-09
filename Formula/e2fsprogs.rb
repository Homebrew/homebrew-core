class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.9/e2fsprogs-1.43.9.tar.gz"
  sha256 "5be0ffc01b9720a3f3ccfc86396016baf1334b98751fefa09e0c63eaffdc3897"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "8c1125d7019a699d729d9d8ad291d6a4c6f7f5d17478524624c0712a982900c9" => :high_sierra
    sha256 "9cedd40f0ee2a99581660e1896773dd39481986b5ca26c859443877eb40fd599" => :sierra
    sha256 "73a5a2a59adc18a53bb39fbde3f6efd34adf6b4289a5447afdd12d09af9b35ab" => :el_capitan
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
