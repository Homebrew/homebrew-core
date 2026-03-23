class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.3.0/avfs-1.3.0.tar.bz2"
  sha256 "07cd69d4c0c7ed080e80ff040d980286405ad38a443fdc52dc395efef11c44b1"
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
    sha256 arm64_linux:  "d85a19151e210f1c932804b20149eb0cea8684cb4ba51796321e83c78f03f2f1"
    sha256 x86_64_linux: "688b2dcaa878db660e2ec1a05b98376cd388aeb616bb6391cf4904f7a7625258"
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
