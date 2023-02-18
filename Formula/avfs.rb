class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.5/avfs-1.1.5.tar.bz2"
  sha256 "ad9f3b64104d6009a058c70f67088f799309bf8519b14b154afad226a45272cf"
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
    rebuild 1
    sha256 x86_64_linux: "32fa53bd6af3f41059f363e42069fee2455442dec722834ac4b47299cce5ec7d"
  end

  depends_on "pkg-config" => :build
  depends_on "bzip2"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-fuse",
                          "--enable-library",
                          "--with-system-zlib",
                          "--with-system-bzlib",
                          "--with-xz"
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
