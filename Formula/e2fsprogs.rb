class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.8/e2fsprogs-1.43.8.tar.gz"
  sha256 "3f32f481f408b7f248acf00ea3e423c348d2a17ff51ed0dfa892d171551ec3de"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "f6d48c6716470cb8c86734967dfb487b7422d0b87e8e77c93588949b966df794" => :high_sierra
    sha256 "3b987c5b9aa5b88deb20ef33d346da71d2bb18d2babfa75bc8c88a1b064c43c5" => :sierra
    sha256 "0eb803fc56187cb43ff8898d8d18936abb9ad9dac0cd8cc944eda142466f6064" => :el_capitan
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
