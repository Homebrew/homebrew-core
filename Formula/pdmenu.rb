class Pdmenu < Formula
  desc "Full screen menuing system for Unix"
  homepage "https://joeyh.name/code/pdmenu/"
  url "http://sources.buildroot.net/pdmenu/pdmenu-1.3.6.tar.gz"
  sha256 "dedd2a4a5719278b5e49041161990c2f20b5909818837542aaca01819f2c14eb"
  license "GPL-2.0-only"

  depends_on "coreutils" => :build
  depends_on "gettext"
  depends_on "s-lang"

  def install
    # should be fixed in the upcoming 1.3.7
    inreplace "autoconf/makeinfo.in",
      "LIBS		= @LIBS@ $(EFENCE)",
      "LIBS		= @LIBS@ @INTLLIBS@ $(EFENCE)"

    # we cannot actually use "/usr/share/locale"
    inreplace "Makefile",
      "LOCALEDIR	= $(INSTALL_PREFIX)/usr/share/locale",
      "LOCALEDIR	= $(INSTALL_PREFIX)#{prefix}/locale"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdmenu -v")

    # check some strings from the default menu
    ENV["TERM"] = "vt220"
    s = pipe_output("#{bin}/pdmenu")
    assert_match "Main Menu", s
    assert_match "Welcome to Pdmenu ", s
    assert_match " by Joey Hess <pdmenu@joeyh.name>", s
  end
end
