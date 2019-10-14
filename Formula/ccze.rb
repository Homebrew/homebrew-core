class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://deb.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8db7bc8c44c05aa107468a5f0b6e3d56a7072f698d85337cb97efa537b20d424" => :catalina
    sha256 "22a65a5daecfba0918a535040b81a7ba75a01b9421742c6de80e28bc88721fc5" => :mojave
    sha256 "506875e8cc54203395a7aad87f8e1d4eebaa0ecc55095556e0f27c214b9fd23f" => :high_sierra
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
