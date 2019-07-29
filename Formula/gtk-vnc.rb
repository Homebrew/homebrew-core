class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz"
  sha256 "3a9a88426809a5df2c14353cd9839b8c8163438cb708b31d8048c79d180fcab7"
  revision 1

  bottle do
    sha256 "9a9ede3c57a077ae5c902388bad783b6a808ef7f4c80f0f9eb8a51a3cecea9c1" => :mojave
    sha256 "dd9cba44071679e9c8d64520a63e83c7e0349bd96050c1a24f47efe0ee656f2f" => :high_sierra
    sha256 "1b5d1a04226901626d222b0c0df62eb7f76cddaabb8596ae18c0a571e5dfad9b" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  # Fails with Xcode 7.1 or older
  # error: use of undeclared identifier 'MAP_ANONYMOUS'
  # Upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=602371
  depends_on :macos => :yosemite

  def install
    args = %W[
      --prefix=#{prefix}
      --with-gtk=3.0
      --with-examples
      --disable-vala
      --enable-introspection
    ]

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
