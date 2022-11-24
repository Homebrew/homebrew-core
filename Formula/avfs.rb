class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.4/avfs-1.1.4.tar.bz2"
  sha256 "3a7981af8557f864ae10d4b204c29969588fdb526e117456e8efd54bf8faa12b"
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
    sha256 x86_64_linux: "6e490770e6562a092085e1a0855e7d6c988a6d8ce9d5cafdcbde082baea8679b"
  end

  depends_on "pkg-config" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@1.1"
  depends_on "xz"

  def install
    args = %W[
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
