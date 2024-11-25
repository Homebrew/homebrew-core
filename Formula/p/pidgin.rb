class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.13/pidgin-2.14.13.tar.bz2"
  sha256 "120049dc8e17e09a2a7d256aff2191ff8491abb840c8c7eb319a161e2df16ba8"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/Pidgin/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:  "4daf91819dc1a364ada4442d63358657b5cfe68a0e1228fd32d835caf0de1fbd"
    sha256 arm64_ventura: "30eccf131427daec7b0138ba20c556087e5dbe52d5f9511d9966a0c7050581ab"
    sha256 sonoma:        "aeb00e3b89912e895925c3164e673c337aca159acf97352cded6b78992e68443"
    sha256 ventura:       "2534635abc7029ca83767ff1ad5e49cff3e297a4c07c905c5429b32d1864eb60"
    sha256 x86_64_linux:  "71e0c8873098b5a1bca073c324da03a5848f3fd8d96100afa854f7c4c608d363"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libgcrypt"
  depends_on "libgnt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "ncurses" # due to `libgnt`
  depends_on "pango"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "perl"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "perl-xml-parser" => :build
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxscrnsaver"
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
    sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
  end

  def install
    unless OS.mac?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      # Fix linkage error due to RPATH missing directory with libperl.so
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    ENV["ac_cv_func_perl_run"] = "yes" if OS.mac? && MacOS.version == :high_sierra
    if DevelopmentTools.clang_build_version >= 1600
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-int-conversion"
    end

    args = %W[
      --disable-avahi
      --disable-dbus
      --disable-doxygen
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --enable-consoleui
      --enable-gnutls
      --with-ncurses-headers=#{Formula["ncurses"].opt_include}
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
      ]
    end

    # patch pidgin to read plugins and allow them to live in separate formulae which can
    # all install their symlinks into these directories. See:
    #   https://github.com/Homebrew/homebrew-core/pull/53557
    inreplace "finch/finch.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/finch\""
    inreplace "libpurple/plugin.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/purple-2\""
    inreplace "pidgin/gtkmain.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/pidgin\""
    inreplace "pidgin/gtkutils.c", "DATADIR", "\"#{HOMEBREW_PREFIX}/share\""

    system "./configure", *args, *std_configure_args
    system "make", "install"

    resource("pidgin-otr").stage do
      ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    system bin/"finch", "--version"
    system bin/"pidgin", "--version"

    pid = spawn(bin/"pidgin", "--config=#{testpath}")
    sleep 5
    Process.kill "SIGTERM", pid
  end
end
