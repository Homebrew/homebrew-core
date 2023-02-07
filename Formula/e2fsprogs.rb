class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
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
    sha256 arm64_ventura:  "e0f6bc2a122f8907b42911d45cf0d30f7acbc9ab9a30e8488a712b458307d42b"
    sha256 arm64_monterey: "c152340d0ebce9eb437a15b747cc92ef5f08fa61c58b7a1d9386104728fa8fc3"
    sha256 arm64_big_sur:  "bd4c36e5f5741471df258d4164ffaf53790467e4206a4c248c47f6667ec1e564"
    sha256 ventura:        "a5d8fcd407f09d7ef11e7180ec5e1ad2db7143e66dfbb5f0cb2276b53b508a89"
    sha256 monterey:       "899d70651a9a571aa55ab7b8a3f6e4616e1f4cc0856e22c2a5c79b5b64bbd25f"
    sha256 big_sur:        "d9251812c87a30083a9f1b9a12605f8dce0e443a9aa09e85a5891544f356c54c"
    sha256 x86_64_linux:   "b2854383f1ee6e3b360012d2a53b7e0043c480084d5b35a9d1b8d9f639e26252"
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
