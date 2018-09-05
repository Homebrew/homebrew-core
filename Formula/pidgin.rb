class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.13.0/pidgin-2.13.0.tar.bz2"
  sha256 "2747150c6f711146bddd333c496870bfd55058bab22ffb7e4eb784018ec46d8f"
  revision 2

  bottle do
    sha256 "4ebf5677a98572c213b2b2a0a15145140affd52ad659a1bf71da6c705651cea0" => :mojave
    sha256 "39388fd5f805236cb972d68da78f54cbb042f650a2194c6fbb4231dd2f2a2fb0" => :high_sierra
    sha256 "3e89f23e44404b8299562785f612259140d25c8b1af4c5c77d9da0008d1bdd84" => :sierra
    sha256 "5bb5d41124e21b68b6172c025f0faf342d70a87fd95da067b7c450b76d3ab8cb" => :el_capitan
  end

  option "with-perl", "Build Pidgin with Perl support"
  option "without-gui", "Build only Finch, the command-line client"

  deprecated_option "perl" => "with-perl"
  deprecated_option "without-GUI" => "without-gui"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gsasl" => :optional
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "glib"

  if build.with? "gui"
    depends_on "gtk+"
    depends_on "cairo"
    depends_on "pango"
    depends_on "libotr"
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
    sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-doxygen
      --enable-gnutls=yes
      --disable-dbus
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --without-x
    ]

    args << "--disable-perl" if build.without? "perl"
    args << "--enable-cyrus-sasl" if build.with? "gsasl"

    args << "--with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    args << "--with-tkconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework"
    args << "--disable-gtkui" if build.without? "gui"

    system "./configure", *args
    system "make", "install"

    if build.with? "gui"
      resource("pidgin-otr").stage do
        ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
        ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
        system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/finch", "--version"
  end
end
