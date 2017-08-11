class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.5/e2fsprogs-1.43.5.tar.gz"
  sha256 "ee0f36d11b05baff4005d2bedde01ddd521251712e518b3bf398c7e389493f9a"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "73d6b3dfb8e826533e31cc4a0d15bf865c17927188ec29003f4a054d57b10d1b" => :sierra
    sha256 "047f64a2d4125fdf03e36ab52da22849a6cd88285cce2a166097bd5f24babc78" => :el_capitan
    sha256 "007f8acf3e5f7ae4791f72920d3875db0cf77bb694126fbe9d9815d47c6ce658" => :yosemite
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
