class Mandoc < Formula
  desc "UNIX manpage compiler toolset"
  homepage "https://mandoc.bsd.lv/"
  url "https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz"
  sha256 "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c"
  license "ISC"
  revision 1
  head "anoncvs@mandoc.bsd.lv:/cvs", using: :cvs

  livecheck do
    url "https://mandoc.bsd.lv/snapshots/"
    regex(/href=.*?mandoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e52aaa74b6654469741aa21738507e636c4b09576109ff602f78a445a4ce30dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086aeecdaad50178bb76546745cf350195ed758d02a495e4128c1dc210ec5b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86fc7de6ddf02952dd6615916d2a787d0e87954337d7b214c760f3871575a771"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a009788bd3b10af69f0563904143dda9a41f0872514ac7e64e8a08a46fcf5fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cf397d08e94ff1666fcb58ebeb06d70e86d9fe243291fd2ebc66b5724bc4af4"
    sha256 cellar: :any_skip_relocation, ventura:        "b328a5df78ce08be360ed248be3fa61b83b4a485c9cf0159351b4049735bf2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "6e8f22f43770525c78280535cf293a4500eba441baab688dbe04e4c872a505a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f63ae6f10fe8912986b92fecc22f7421ed0bad4495811f6159b895d5b42f6d"
    sha256 cellar: :any_skip_relocation, catalina:       "0190c6cc439cedfb1eb83d60b5be68974e12b993bafc87387ced2b948b526a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048e9149279a52292a203c6e6b4fd688b7b32501b8e05d806a5708587526a83c"
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
      "BINM_SOELIM=bsdsoelim", # conflicts with groff's soelim

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}", # ? See configure.local.example, NEWS.
      "BUILD_CGI=1",
    ]

    # Bottom corner signature line.
    localconfig << if OS.mac?
      "OSNAME='macOS #{MacOS.version}'"
    else
      "OSNAME='Linux'"
    end

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
