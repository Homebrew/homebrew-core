class Fsarchiver < Formula
  desc "File system archiver for linux"
  homepage "https://www.fsarchiver.org"
  url "https://github.com/fdupoux/fsarchiver/releases/download/0.8.7/fsarchiver-0.8.7.tar.gz"
  sha256 "f7cd059e70fc57e888db282c622ec050c0dcdbaacc65e3c1eb163cd9d92d810d"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "bzip2"
  depends_on "e2fsprogs"
  depends_on "libgcrypt"
  depends_on :linux
  depends_on "lz4"
  depends_on "lzo"
  depends_on "util-linux"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = [
      "--enable-elf-shlibs",
      "--disable-fsck",
      "--disable-uuidd",
      "--disable-libuuid",
      "--disable-libblkid",
      "--without-crond-dir",
      "--sysconfdir=#{etc}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args

    system "make"
    system "make", "install"
  end

  test do
    system bin/"fsarchiver", "usage"
  end
end
