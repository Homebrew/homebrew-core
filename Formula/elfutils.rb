class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects."
  homepage "https://fedorahosted.org/elfutils/"
  url "https://fedorahosted.org/releases/e/l/elfutils/0.163/elfutils-0.163.tar.bz2"
  sha256 "7c774f1eef329309f3b05e730bdac50013155d437518a2ec0e24871d312f2e23"
  # tag "linuxbrew"

  bottle do
    sha256 "99c141bcce532d5f70a3754028faf3c6c93ed3e6c6861ad633173ad334afef5e" => :x86_64_linux
  end

  depends_on "xz"
  depends_on "bzip2" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  fails_with :clang do
    build 700
    cause "gcc with GNU99 support required"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--program-prefix=elfutils-",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = `#{bin}/elfutils-nm #{bin}/elfutils-nm`
    assert_match /elf_kind/, output
  end
end
