class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  revision 1

  bottle do
    sha256 "7eb127c4017e7530a53e3258f6b013e80fca1a0d30c577813bdc326b8b0e30d3" => :el_capitan
    sha256 "3bf7f9c6ab3410d73348d4f0518f4778ca2e832904f992004bd3a438d2fcd036" => :yosemite
    sha256 "8714d3dbc5bc165b505180b9833fbcdda609e978c6c821ac7a503cd4226619aa" => :mavericks
  end

  depends_on "pcre"

  def install
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823334
    inreplace "src/ccze-compat.c", "#if HAVE_SUBOPTARg", "#if HAVE_SUBOPTARG"
    # Allegedly from Debian & fixes compiler errors on old OS X releases.
    # https://github.com/Homebrew/legacy-homebrew/pull/20636
    inreplace "src/Makefile.in", "-Wreturn-type -Wswitch -Wmulticharacter",
                                 "-Wreturn-type -Wswitch"

    system "./configure", "--prefix=#{prefix}",
                          "--with-builtins=all"
    system "make", "install"
    # Strange but true: using --mandir above causes the build to fail!
    share.install prefix/"man"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end
