class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.1/e2fsprogs-1.47.1.tar.gz"
  sha256 "9afcd201f39429d2db2492aeb13dba5e75d6cc50682b732dca35643bd5f092e3"
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
    sha256 arm64_sequoia:  "fe6514a7b9690195806c16b1eebeaf0a991f0944c6cfe76681a4c57e07e8a660"
    sha256 arm64_sonoma:   "98368d23728fb485ff67766148c8aee4bbeee3c542ba0d5c200cb608aedb8e1a"
    sha256 arm64_ventura:  "2226708887d3d43427d39d355a75b2367d7ecf5145621de5dae2749dd4f130e4"
    sha256 arm64_monterey: "942b459a0a9bc92157d4afa5e0f71d3f14d5ddccb0b8d652c4e70416d6d32cc4"
    sha256 sonoma:         "248320615070b5b3f32ee4c581c46a4e9e74e51c4765624d253aa74a2cc44469"
    sha256 ventura:        "85f74a6d50a82f4e2f2c29e0569cd102034a127e81d0fdef83c15411aa240042"
    sha256 monterey:       "07e61dc2625c27caa877ce698f5c3f5cd2f7aaee3cba6da22d865db7224105ae"
    sha256 x86_64_linux:   "eb63ea295700e11246a09b546f36a360db3c56c227deb4a30e12450e2c76dbab"
  end

  keg_only :shadowed_by_macos

  depends_on "pkg-config" => :build

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
