class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.197/elfutils-0.197.tar.bz2"
  sha256 "1fdf525f22dcf796d99a99ba3ea00a1f7b1ae5421bc62e8443a708920b99b904"
  license all_of: [
    "GPL-3.0-or-later", # programs
    { any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"] }, # libraries
    "GFDL-1.3-no-invariants-or-later", # eu-readelf.1
  ]
  compatibility_version 1

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 arm64_linux:  "016cf02a099a01e3bd164512c49cc98de5e4c7d8b810bd184d5f2ef814d63848"
    sha256 x86_64_linux: "8d8590853f50dc056092afa497854439954ae8c768c1330450a553f702f492ae"
  end

  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  deny_network_access!

  def install
    args = %w[
      --disable-silent-rules
      --disable-libdebuginfod
      --disable-debuginfod
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
    assert_match "elf_kind", shell_output("#{bin}/eu-nm #{bin}/eu-nm")
  end
end
