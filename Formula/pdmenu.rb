class Pdmenu < Formula
  desc "Full screen menuing system for Unix"
  homepage "https://joeyh.name/code/pdmenu/"
  url "http://sources.buildroot.net/pdmenu/pdmenu-1.3.6.tar.gz"
  sha256 "dedd2a4a5719278b5e49041161990c2f20b5909818837542aaca01819f2c14eb"
  license "GPL-2.0-only"

  head "git://git.joeyh.name/pdmenu"

  depends_on "gettext" => :build
  depends_on "s-lang" => :build

  def install
    ENV.append "CC", "-I#{HOMEBREW_PREFIX}/include"
    ENV.append "SLANG_H_LOC", "#{HOMEBREW_PREFIX}/include/slang.h"
    ENV.append "SLANG_LIB_LOC", "#{HOMEBREW_PREFIX}/lib"
    ENV.append "INSTALL", "#{HOMEBREW_PREFIX}/bin/ginstall"

    # should be fixed in the upcoming 1.3.7
    system "sed", "-i", "-c", "s?^LIBS.*$?LIBS           = @LIBS@ @INTLLIBS@ $(EFENCE)?", "autoconf/makeinfo.in"

    # we cannot use "/usr/share/locale"
    system "sed", "-i", "-c", "s?^LOCALEDIR.*$?LOCALEDIR      = $(INSTALL_PREFIX)/#{prefix}/locale?", "Makefile"

    system "./configure", "--prefix=#{prefix}", "--with-libiconv-prefix=#{HOMEBREW_PREFIX}"
    system "make"
    mkdir pkgshare.to_s
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdmenu -v")
  end
end
