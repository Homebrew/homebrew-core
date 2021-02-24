class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.1/e2fsprogs-1.46.1.tar.gz"
  sha256 "49630dc777a808dc67312fa289dca65b9d2dbad80c8267f3b9d437b7167774e4"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "56c580421ac3e50f75ee5474d30e49bdc1cded6e27ff0fab37bb37012bb55375"
    sha256 big_sur:       "59bf8ad4be4b70fecf03d38e8de4a0623aacc8e9730b07cb973cbc069b0760b3"
    sha256 catalina:      "09d3f58b3e0018a3293ae3274407143e016c7197b11896a4a3d1545e211c4627"
    sha256 mojave:        "35273b86257cb93032ba6d57293c0c7a1c5d658c12b26c52da5c8324e075f9ba"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    # Fix "unknown type name 'loff_t'" issue
    inreplace "lib/ext2fs/imager.c", "loff_t", "off_t"
    inreplace "misc/e2fuzz.c", "loff_t", "off_t"

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
