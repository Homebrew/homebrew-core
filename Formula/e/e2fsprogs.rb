class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.4/e2fsprogs-1.47.4.tar.gz"
  sha256 "2cec05f39c20ee621f14926195664e66e6017190ac8e4bbdb16d86082e43c5da"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  compatibility_version 1
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "f8024861ae8b5a645374d7960a5b5e3c41576c792712925d55deb186a74a1d06"
    sha256 arm64_sequoia: "753c95aef34725e1bc3a4778a6c3073596b8b3a2b32bb18ec4f361fce747813b"
    sha256 arm64_sonoma:  "c2c812d2da0ef0aa70a6f4962c832fd6636efad99344941ce0654173e7c8a297"
    sha256 sonoma:        "5985432543778c6ebd6358ecaa2f9fb508c1a9cc6393117597d505b489d8a7a3"
    sha256 arm64_linux:   "7dc8e4683b77882347b8dcd2cc2b82f2943fca8c30db51795bf33d2f260fd7f5"
    sha256 x86_64_linux:  "28c57ec49ba06d7c371755737e6ab04a23fa733ef82a83b05a9da2871e8f8215"
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
