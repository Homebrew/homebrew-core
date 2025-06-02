class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.2/e2fsprogs-1.47.2.tar.gz"
  sha256 "6dcd67ff9d8b13274ba3f088e4318be4f5b71412cd863524423fc49d39a6371f"
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
    sha256 arm64_sequoia: "a6ca9c2d59683ed1f7d97cb2fbf2abae9bcaf4cb3af2cc451c42fb25f2d0931b"
    sha256 arm64_sonoma:  "75fda5c12d0363d8bd5fb2721bff367361369abdd16a7fd9dae612c5264fce45"
    sha256 arm64_ventura: "70e8e92b42117b3161e431f6c9de55f754d7e358b4cd74a0a281807828a98004"
    sha256 sonoma:        "129f5d0b2dc865c6c2d7a2959a71667236b10cbd8a8abbbc5424df73d788ee58"
    sha256 ventura:       "aaa928d296c1b82a64b89183d5005d3c98bbbc51cb17aa1151b5850519c9b947"
    sha256 arm64_linux:   "a9a234b1cf8d877076694954b306e91039e40e3c46c2e5394f67c29a6add1762"
    sha256 x86_64_linux:  "42721911833f1c21f50d2ed01327f86b0470995cdcfc8d48dcc7af5c7b0cc8a6"
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
