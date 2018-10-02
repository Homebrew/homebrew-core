class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz"
  sha256 "3a9a88426809a5df2c14353cd9839b8c8163438cb708b31d8048c79d180fcab7"

  bottle do
    rebuild 1
    sha256 "677145986939e0fe9c01a2fccbd492b06acbe47c58ec7d13f3b13d1f52532304" => :mojave
    sha256 "510531935bb5d84e4a57c44aec6e62b0b3885f3ba3e4f41add15fcb17b60adf9" => :high_sierra
    sha256 "1c846c72d56f987696174c43d4251e4966787435245ffc3ba40aee671e9e1a38" => :sierra
    sha256 "6a624b5f4aa844fe69695d72b8f7c65dea5cc1c2328404c0c78c9670b2c952ac" => :el_capitan
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
