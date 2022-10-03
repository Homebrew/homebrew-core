class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.10/pidgin-2.14.10.tar.bz2"
  sha256 "454b1b928bc6bcbb183353af30fbfde5595f2245a3423a1a46e6c97a2df22810"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/Pidgin/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_monterey: "d373785c6d71ff6edf71acd84a25dce77016f678d59d2d8f714da5bd27398e71"
    sha256 arm64_big_sur:  "830c1c5fe7e10ff46b44e4fb9e97cba440f73bc3aedb7d5689322fad63472eca"
    sha256 monterey:       "040db181ed8a2eaaaf07de46da4594bfe29619d1229a89363f77053bf27bf486"
    sha256 big_sur:        "0cc1dde1b0766557ae85ef0ce4ecf2b84e4ac4a36f7947eaa71573ea0547cb9f"
    sha256 catalina:       "01ddce452da50c258598b58d18c2be976e94bbbbae63581c11d05e5bd197cc66"
    sha256 x86_64_linux:   "0b20be6c06ab99805b3a3113322be80ab32aa572c542551d9cd2b482ee665380"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libgcrypt"
  depends_on "libgnt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "pango"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "ncurses"
  uses_from_macos "perl"
  uses_from_macos "tcl-tk"

  on_linux do
    depends_on "libsm"
    depends_on "libxscrnsaver"
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
    sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-dbus
      --disable-doxygen
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --enable-gnutls=yes
    ]

    args += if OS.mac?
      %W[
        --with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
        --with-tkconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework
        --without-x
      ]
    else
      %W[
        --with-tclconfig=#{Formula["tcl-tk"].opt_lib}
        --with-tkconfig=#{Formula["tcl-tk"].opt_lib}
        --with-ncurses-headers=#{Formula["ncurses"].opt_include}
      ]
    end

    ENV["ac_cv_func_perl_run"] = "yes" if MacOS.version == :high_sierra

    # patch pidgin to read plugins and allow them to live in separate formulae which can
    # all install their symlinks into these directories. See:
    #   https://github.com/Homebrew/homebrew-core/pull/53557
    inreplace "finch/finch.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/finch\""
    inreplace "libpurple/plugin.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/purple-2\""
    inreplace "pidgin/gtkmain.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/pidgin\""
    inreplace "pidgin/gtkutils.c", "DATADIR", "\"#{HOMEBREW_PREFIX}/share\""

    system "./configure", *args
    system "make", "install"

    resource("pidgin-otr").stage do
      ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/finch", "--version"
    system "#{bin}/pidgin", "--version"

    pid = fork { exec "#{bin}/pidgin", "--config=#{testpath}" }
    sleep 5
    Process.kill "SIGTERM", pid
  end
end
