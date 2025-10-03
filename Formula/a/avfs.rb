class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.2.0/avfs-1.2.0.tar.bz2"
  sha256 "a25a8ec43c1ee172624e1a4c79ce66a1b930841cdb545b725f1ec64bcabe889c"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-only", # for shared library
    "GPL-2.0-or-later", # modules/dav_ls.c
    "Zlib", # zlib/*
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/avfs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_linux:  "81825d0ffa76826644f47b69036175d85182751c891a0fcb06e27a8dd1a09a50"
    sha256 x86_64_linux: "44c9d1451dd67af972b90f625e38f9a48b089dbfbbf2b76b4d2e6ac668e61eb5"
  end

  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-fuse",
                          "--enable-library",
                          "--with-system-zlib",
                          "--with-system-bzlib",
                          "--with-xz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
