class Mandoc < Formula
  desc "UNIX manpage compiler toolset"
  homepage "https://mandoc.bsd.lv/"
  url "https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz"
  sha256 "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c"
  license "ISC"
  head "anoncvs@mandoc.bsd.lv:/cvs", using: :cvs

  livecheck do
    url "https://mandoc.bsd.lv/snapshots/"
    regex(/href=.*?mandoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "961503c6406f83c6e7969e5dbdfd8788caf68d0ccc613b81d198233f9ca42e60"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5f577c8cbbe699076db1412944b56ee5c9d6537cef4d69bb4988ac3a1be74b1"
    sha256 cellar: :any_skip_relocation, catalina:      "8a5308647cb76d0c9a2ff8d6c59cb52319fbfd0eba1135fced543e5f9b3a63a7"
    sha256 cellar: :any_skip_relocation, mojave:        "1b7c8c7c3cdf95bf6dcb0300aecbfbc591ea48588d23fcf65b8f61f0e65cc86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c7c708347a1805a8e1482512bd475a50c8ea2f2030fca56819ada67b1b3c513"
  end

  uses_from_macos "zlib"

  def install
    localconfig = [

      # Sane prefixes.
      "PREFIX=#{prefix}",
      "INCLUDEDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      "WWWPREFIX=#{prefix}/var/www",
      "EXAMPLEDIR=#{share}/examples",

      # Executable names, where utilities would be replaced/duplicated.
      # The mandoc versions of the utilities are definitely *not* ready
      # for prime-time on Darwin, though some changes in HEAD are promising.
      # The "bsd" prefix (like bsdtar, bsdmake) is more informative than "m".
      "BINM_MAN=bsdman",
      "BINM_APROPOS=bsdapropos",
      "BINM_WHATIS=bsdwhatis",
      "BINM_MAKEWHATIS=bsdmakewhatis", # default is "makewhatis".

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      "OSNAME='Mac OS X #{MacOS.version}'", # Bottom corner signature line.

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}", # ? See configure.local.example, NEWS.
      "BUILD_CGI=1",
    ]

    File.rename("cgi.h.example", "cgi.h") # For man.cgi

    (buildpath/"configure.local").write localconfig.join("\n")
    system "./configure"

    # I've tried twice to send a bug report on this to tech@mdocml.bsd.lv.
    # In theory, it should show up with:
    # search.gmane.org/?query=jobserver&group=gmane.comp.tools.mdocml.devel
    ENV.deparallelize do
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css", "#{man1}/mandoc.1"
  end
end
