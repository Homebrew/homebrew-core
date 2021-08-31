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
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "5b854e0ccf3d4455570b84e1a4694d6a5f3ea6cc8d80a3b5356ebec32eafa63b"
    sha256 big_sur:       "d3337fe5a93d5b47e93cb353f08027a5d9c83f7729cddfed7804fc1479138f89"
    sha256 catalina:      "af4cc5453ef9c0a2d19a157657d4c09212b0632d7cfc2cb2279d45e9212aa2d2"
    sha256 mojave:        "d2cec63941cae2d21631eb5d4e486f46736a98a4f3dfe86e3dae6b9cd7bf7ba5"
    sha256 x86_64_linux:  "74e93b5a2932db3116ff1912bff5a8b72605a3cdd4c0eba3640c669b70a8ee8e"
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
