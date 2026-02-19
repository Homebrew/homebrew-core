class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.194/elfutils-0.194.tar.bz2"
  sha256 "09e2ff033d39baa8b388a2d7fbc5390bfde99ae3b7c67c7daaf7433fbcf0f01e"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]
  revision 1

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 arm64_linux:  "1ca43cc8af9766635f9484f007cd79152c35ddaf434e44eb8eaf79b7ca8682a3"
    sha256 x86_64_linux: "4f5ee54efe423d3ac486aa5372af4ca8debf2e2626ef16d480e4c79f1681b2de"
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
