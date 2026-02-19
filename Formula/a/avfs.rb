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
    rebuild 1
    sha256 arm64_linux:  "673d7ce1b1e9df7811bb2d504b62f32e543f8781e1e75f8c16494011671abff2"
    sha256 x86_64_linux: "595c36f4676d448414a2e25606758c50a5cadf673f5d3fbd49d2e9e5dbaf1077"
  end

  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
