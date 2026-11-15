class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.4.0/avfs-1.4.0.tar.bz2"
  sha256 "d4dcdaf5afd7ba146334b6d003600340011c97307d84229ece09fe684448f98e"
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
    sha256 arm64_linux:  "ac51b01c84fbfef1e9c0772ff4461db668ef7eb1e7afe73440bb8ec77ea7ac6b"
    sha256 x86_64_linux: "895ffb92e873e6275a5fa024d535d469679f0931cdac2841b4604eb54bb4c45b"
  end

  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
