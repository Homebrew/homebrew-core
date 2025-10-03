class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.3/e2fsprogs-1.47.3.tar.gz"
  sha256 "2f5164e64dd7d91eadd1e0e8a77d92c06dd7837bb19f1d9189ce1939b363d2b4"
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
    sha256 arm64_tahoe:   "cf282a67dba8d6df346d2cced1c23b024517299c13a7d8558121dd6730bc19c6"
    sha256 arm64_sequoia: "0425f6b5ae2cfd69bce77df9368dae0b237abdf27f02de2eddfa799c84ff44f3"
    sha256 arm64_sonoma:  "2104bdc9d9d3ca85605ec7a3a897ca4f810ceaef1e2c560def59b04b2dd18074"
    sha256 arm64_ventura: "316a532eec3aa1ef23259fce5cbb692f2d04540b9eca3f54393c55e4d336a8e7"
    sha256 sonoma:        "f56432934bf673ee57900c3be5f9da1dd7341d2f6465642b106729361e2c77da"
    sha256 ventura:       "cf1bb22c088497db81c2ff02b71257ac5886e4c810c792302572768608987b12"
    sha256 arm64_linux:   "dc14ab2441da84c2d2db5baea06deb6bc6dae44ae5f9818849f005664c58a6d0"
    sha256 x86_64_linux:  "d66bd31538beae13ac1db1d4f53a81cf32ec32d0bcc9e17bc7b32d33420eedcb"
  end

  keg_only :shadowed_by_macos

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    keg_only "it conflicts with the bundled copy in `krb5`"

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
