class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.188/elfutils-0.188.tar.bz2"
  sha256 "fb8b0e8d0802005b9a309c60c1d8de32dd2951b56f0c3a3cb56d21ce01595dff"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    sha256 x86_64_linux: "f70a0566d30f6eb37d86c909d54bd0c7b5da24433da2aa21601f83a58899e818"
  end

  depends_on "m4" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--disable-libdebuginfod",
           "--disable-debuginfod",
           "--program-prefix=elfutils-",
           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/elfutils-nm")
  end
end
