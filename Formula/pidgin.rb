class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.13.0/pidgin-2.13.0.tar.bz2"
  sha256 "2747150c6f711146bddd333c496870bfd55058bab22ffb7e4eb784018ec46d8f"
  revision 3

  bottle do
    rebuild 1
    sha256 "5447d58ebdfdbb28a8488c9fa0d77e4aee6787955826e2674cf53ba903268638" => :mojave
    sha256 "735db47d591766486801549430960db2e83651ee373add2901ef71333eefea75" => :high_sierra
    sha256 "f862f996bd1a302d21b13182cc9ac2ba4a00b6a87b63f0a78c9d6a7c2f293b6a" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "pango"

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
      --disable-dbus
      --disable-doxygen
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --enable-gnutls=yes
      --with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --with-tkconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework
      --without-x
    ]

    ENV["ac_cv_func_perl_run"] = "yes" if MacOS.version == :high_sierra

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
  end
end
