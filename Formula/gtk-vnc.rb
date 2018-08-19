class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz"
  sha256 "3a9a88426809a5df2c14353cd9839b8c8163438cb708b31d8048c79d180fcab7"

  bottle do
    sha256 "46f9946e8e7fbfe9003b615350e750795514d0be5ab2ce93232daccc556cd0e1" => :high_sierra
    sha256 "d519139009c47cc5673efd583ed08d022babfa9315f78d87a0c0d35260f33a6f" => :sierra
    sha256 "e7c133b6fa20f0c68cb50bb773c80c7e747571dfeaddded32b1fee52c45a5c4b" => :el_capitan
  end

  # Fails with Xcode 7.1 or older
  # error: use of undeclared identifier 'MAP_ANONYMOUS'
  # Upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=602371
  depends_on :macos => :yosemite

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"
  depends_on "pulseaudio" => :optional
  depends_on "vala" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-gtk=3.0
      --with-examples
      --enable-introspection
    ]

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
