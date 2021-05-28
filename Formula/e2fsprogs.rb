class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.2/e2fsprogs-1.46.2.tar.gz"
  sha256 "f79f26b4f65bdc059fca12e1ec6a3040c3ce1a503fb70eb915bee71903815cd5"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  revision 1
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "1e0cdd0fdb3195c51b5c8945ee6940831c996b7a43bed64ae44793eedec30f5b"
    sha256 big_sur:       "5867593150f8074619181fb886e614d799be0fa241e579875593e8c4cadcd900"
    sha256 catalina:      "567cf6795aebc06c1f1d99051800bcd55195061062398bad92049a38bb343890"
    sha256 mojave:        "fd0cb15c18294ce9072377f0833b73302011efc1087c9fdc4fce3e730839c717"
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
    args = [
      "--prefix=#{prefix}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]
    on_macos do
      args << "--enable-bsd-shlibs" unless Hardware::CPU.arm?
    end
    on_linux do
      args << "--enable-elf-shlibs"
    end

    system "./configure", *args

    system "make"

    # Fix: lib/libcom_err.1.1.dylib: No such file or directory
    ENV.deparallelize

    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
