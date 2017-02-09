class GtkVnc < Formula
  desc "VNC viewer widget for GTK."
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.7/gtk-vnc-0.7.0.tar.xz"
  sha256 "3c2eae7c9053338939a32c9987156a12b802ffd5c7f80702ba8d483dfc6d483e"

  bottle do
    sha256 "e6295f47c9b7b509cd8d8014770d1830ccf3948517b48a725f1ffa7cd309cfcd" => :sierra
    sha256 "8989a4351aebfdb2510e8f3ab8b3048e14781c09ae63cb4cc3fd1c10ed5da054" => :el_capitan
    sha256 "221d067174aaee6f1f2875b143c905db8677da91e31e251c706649da9951816e" => :yosemite
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
