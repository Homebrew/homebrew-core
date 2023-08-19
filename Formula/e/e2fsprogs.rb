class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.0/e2fsprogs-1.47.0.tar.gz"
  sha256 "6667afde56eef0c6af26684974400e4d2288ea49e9441bf5e6229195d51a3578"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "32c3579e1a33775074fb35ae5e6f499682da918d6310a653600bb3a97b3ac235"
    sha256 arm64_monterey: "b7fe9f7b148e778ef9b4d9d6bc97d39fdc942436692b33b518ff1cc85d2b123b"
    sha256 arm64_big_sur:  "b81365c6dafa1ddf9d37fb0ac9b748f70c832ed01c48a97ccb030bfe35ced118"
    sha256 ventura:        "e3bb6dbd23b93bfa37ada501134be5ab997ea98b62d800f3e448cd1e627a9bcb"
    sha256 monterey:       "bc1f1731ebae67bcfd0426e72e0dda411d0737103996344cf351f469e5c6b5f6"
    sha256 big_sur:        "5fb3d45aa2cd60cd733f346f2433f3b203c7f06065d901efbcb28d207081186e"
    sha256 x86_64_linux:   "fd9a98171952631479167b5777230f041b2b81cab97f68b2437e3821e472aed4"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]
    args += if OS.linux?
      %w[
        --enable-elf-shlibs
        --disable-fsck
        --disable-uuidd
        --disable-libuuid
        --disable-libblkid
        --without-crond-dir
      ]
    else
      ["--enable-bsd-shlibs"]
    end

    system "./configure", *args

    system "make"

    # Fix: lib/libcom_err.1.1.dylib: No such file or directory
    ENV.deparallelize

    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length if OS.mac?
    system bin/"lsattr", "-al"
  end
end
