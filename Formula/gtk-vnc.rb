class GtkVnc < Formula
  desc "VNC viewer widget for GTK."
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.7/gtk-vnc-0.7.1.tar.xz"
  sha256 "f34baa696615ef67666e8465b4d0ac563355e999a77d2cc42ad4625a24f7aab1"

  bottle do
    sha256 "ceb838e4d4f47747d1108b8aac8dfa4b4770331122973631c2d6e1bfad9460a3" => :sierra
    sha256 "ec8719eb4a3ce0dfed33d1f9eb4c79927bac33faae2cc6deeaf579aea282c2be" => :el_capitan
    sha256 "56dea445fa75ae05a7f68cab3e0d75d9931b5479361fc2a5a0e6f1df6ad34ebe" => :yosemite
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
