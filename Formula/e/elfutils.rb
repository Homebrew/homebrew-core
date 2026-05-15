class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.195/elfutils-0.195.tar.bz2"
  sha256 "37629fdf7f1f3dc2818e138fca2b8094177d6c2d0f701d3bb650a561218dc026"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]
  compatibility_version 1

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 arm64_linux:  "463f09ff4d31b7cd73e99b42437071126849962fde8ab8b0c96a64105f7afa06"
    sha256 x86_64_linux: "c465671b13a19bdf9eb686ed3f6a42fe4c404a05ae46b1be58db8da25166a5a8"
  end

  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  def install
    args = %w[
      --disable-silent-rules
      --disable-libdebuginfod
      --disable-debuginfod
      --program-prefix=elfutils-
      --with-bzlib
      --with-lzma
      --with-zlib
      --with-zstd
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/elfutils-nm")
  end
end
