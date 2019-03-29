class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.3.tar.gz"
  sha256 "aad4e735a7ac4a1f8ade20caadb35dfefc2a352fa2ef41d3f6e589179917e1e9"

  bottle do
    rebuild 1
    sha256 "42ca141ab5fb961136002472908906705058a28c06c4cbdea0e6d0651e3ea01e" => :mojave
    sha256 "a9258577e88aff64e554a211e85f94d7a5fe5019730140c909b18288b6c11ae8" => :high_sierra
    sha256 "682e841bdf1312ef6ed1ce6f32fe69b85808fb33ee1738cbf421f5433172aa50" => :sierra
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre $@",
      "clang -E -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
