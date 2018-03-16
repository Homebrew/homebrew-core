class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.44.0/e2fsprogs-1.44.0.tar.gz"
  sha256 "04abf8c2c7c9a70aa3aa9757da23a929baf18423ccd06e8a0320c2effe091fd1"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "8c6fb4dbd79f25cef916d8cf1c920aad4b664e9c3e34203319169f81aae7e731" => :high_sierra
    sha256 "5535649c0a52c298cd0dbe0f16c3c264ff10f891a63f09ccf3f89df7aaabe506" => :sierra
    sha256 "0ff5893c31c405ef00dc1a7db0c240d5834c0a0bc30581b511e0f2e34f32bc84" => :el_capitan
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
