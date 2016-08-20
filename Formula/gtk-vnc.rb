class GtkVnc < Formula
  desc "VNC viewer widget for GTK."
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.6/gtk-vnc-0.6.0.tar.xz"
  sha256 "9559348805e64d130dae569fee466930175dbe150d2649bb868b5c095f130433"

  bottle do
    sha256 "3e542006e50dab1ec526b46a4a8f4e7f2cb81028141f511329c7ece9d615bfa2" => :el_capitan
    sha256 "649dcb517d936e72da2c8e3cff67cd200c51a0b6ebfe60d70bb5f40c03bebf8b" => :yosemite
    sha256 "9d47fee65e698a59d2f90b53f47937745bdd627e0e7e8877daa65192068de7ee" => :mavericks
  end

  # Fails with Xcode 7.1 or older
  # error: use of undeclared identifier 'MAP_ANONYMOUS'
  # Upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=602371
  depends_on :macos => :yosemite

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"
  depends_on "gobject-introspection" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "vala" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-gtk=3.0
      --with-examples
      --with-python
    ]

    args << "--enable-introspection" if build.with? "gobject-introspection"
    args << "--enable-pulseaudio" if build.with? "pulseaudio"
    if build.with? "vala"
      args << "--enable-vala"
    else
      args << "--disable-vala"
    end

    # fix "The deprecated ucontext routines require _XOPEN_SOURCE to be defined"
    ENV.append "CPPFLAGS", "-D_XOPEN_SOURCE=600"
    # for MAP_ANON
    ENV.append "CPPFLAGS", "-D_DARWIN_C_SOURCE"

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gvncviewer", "--help-all"
  end
end
