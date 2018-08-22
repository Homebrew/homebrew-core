class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  revision 1

  bottle do
    sha256 "d1993c584b39fc35c9b03d62677a5944301a64d96a8e72db89f2ba4974939990" => :mojave
    sha256 "6aa074341d1442c6795ece5581a5b404277254d4fdf3a42004d23e32e73824dd" => :high_sierra
    sha256 "7f1d8fb98c7ca95eb938ff2bae748ad081772542234bbd25151cc37e0f097461" => :sierra
    sha256 "795fc9b842f53197ec45774d909fb14efd463a64215fbec799ad870bb78a6834" => :el_capitan
    sha256 "11c34c8ad4df9993b7f465c7c7a7fdb2588e3c75d678f3b22f36166ca1c04520" => :yosemite
    sha256 "40b61bc0353350f43c97f611d26c0826e4e4ce5df0284b1f544e89460af25722" => :mavericks
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
