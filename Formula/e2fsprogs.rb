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
    sha256 arm64_big_sur: "9b51f61594b7f0ec90ce782a45453b598de4b0d3bfecea4468387b2f02321a2b"
    sha256 big_sur:       "833d32db7dfe72ed9edb9bdb330d8b6bcda429bd27f0e6182f3f0276f953e393"
    sha256 catalina:      "4fab548ad74c747095625b6087ab4d59c3efc2fd4bd89f16f24b606ef7b81146"
    sha256 mojave:        "9758f94dc796739e26a1866cf4bea8ae57dcc42eb868072818a52c38b49536a5"
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
