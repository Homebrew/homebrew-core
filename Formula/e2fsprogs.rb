class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.7/e2fsprogs-1.43.7.tar.gz"
  sha256 "87035f2eae8da5f9869f78ffc177969b4e3cf75a5da489521c1ffe4268e1a1c4"

  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "f1d26663be1a1414cd66babd0ff4ad94660b51e4c6e65be676baba4594ebf6c9" => :high_sierra
    sha256 "0d45bca1527d60391699576dbbc45b0d33ef8c11bb9ac1ead3b7ec519cdf3621" => :sierra
    sha256 "3618581e124b8c88804f166695bb40ab329033e903a9177b18e1d12398f4994d" => :el_capitan
    sha256 "7df33cf9daf649aa08fd359dda5dbc9a06c1576b65e082660e6d6935e0760c06" => :yosemite
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
