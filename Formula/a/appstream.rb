class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://github.com/ximion/appstream/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "4470a27474dc3cc4938552fbf0394b6a65d8a2055d4f4418df086d65d8f2ba29"
  license "LGPL-2.1-or-later"

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "libxmlb"
  depends_on "libyaml"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "systemd"
  end

  patch do
    url "https://github.com/ximion/appstream/commit/952cc682c1a39b7e5338d97f0cbee76e911d3979.patch?full_index=1"
    sha256 "b9cb967ab35ee46c6db5dcf83a41922ef1d2f60239a05ad708a4fc4014a90e06"
  end
  patch do
    url "https://github.com/ximion/appstream/commit/0ad6af8a47fa6747f5cbe9b4a7a96ea6d6def0a8.patch?full_index=1"
    sha256 "09eccfde59d35e7559c694410e1763867b2c6dd8454ffce895d1b8be235ca474"
  end

  def install
    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported to the upstream developer by email as a bug tracker does not exist.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    inreplace "meson.build", "/usr/include", prefix.to_s

    args = %w[
      -Dstemming=false
      -Dvapi=true
      -Dgir=true
      -Ddocs=false
    ]

    args << "-Dsystemd=false" if OS.mac?
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <appstream-glib.h>

      int main(int argc, char *argv[]) {
        AsScreenshot *screen_shot = as_screenshot_new();
        g_assert_nonnull(screen_shot);
        return 0;
      }
    EOS
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libappstream-glib
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lappstream-glib
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    system "#{bin}/appstream-util", "--help"
  end
end
