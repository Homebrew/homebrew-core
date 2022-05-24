class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.4/e2fsprogs-1.46.4.tar.gz"
  sha256 "7524520b291e901431ce59ea085955b601126de371bf3cfc0f5e4fad78684265"
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
    sha256 arm64_monterey: "0704bc2eb7f67d1ae9359ce0a88df93c5fea7983bc244aeb056b76ff862bbd90"
    sha256 arm64_big_sur:  "b089beb986fdbc2f9a699c98ea0d7453b434a819b18e09183c8a2e54368b4652"
    sha256 monterey:       "b5f7734b3d5f8fc599814c035f5a81e2b5c519dfa0269d8c777babc794cc9f80"
    sha256 big_sur:        "93c43050723e83dc54e9acda04b49bb9651d561a8f179b0a2837dc0b4dbc488d"
    sha256 catalina:       "e629177b97c03f0c073ab805dd1d452b210f4b206e63da826793420c64d151eb"
    sha256 mojave:         "d494d4d21d05c76acdeb381b38d2bd343cd4d1b5e536a1d2f99ebceb8fb5d917"
    sha256 x86_64_linux:   "cf06e4cdcc4588246eb66b3fd10d9a8424494578e7821e6e273a030fcea09d28"
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
    args << if OS.linux?
      "--enable-elf-shlibs"
    elsif !Hardware::CPU.arm?
      "--enable-bsd-shlibs"
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
