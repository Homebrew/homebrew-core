class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/0.20/gupnp-0.20.17.tar.xz"
  sha256 "c9e415db749e75d82b17de341e6430ebce2a7ce457640c039cfcb03b498a8fd2"

  bottle do
    sha256 "29fa2086eb1e5b2cc6429726e8c483f9a76ce248dffa8ada8c94ac821ad5c2a5" => :el_capitan
    sha256 "c68b27c1706f5e55c679bd306be25a533ba8824944458a0b08ce6d4cb62a3289" => :yosemite
    sha256 "b3b52e8cb6b858ba903cc393a10e8663f79b8d80105d71abc3fe3483057dc18a" => :mavericks
  end

  head do
    url "https://github.com/GNOME/gupnp.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  # REVIEW: if patch was applied in the next release
  # https://github.com/GNOME/gupnp/pull/1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/51584eb/gupnp/patch-osx-uuid.diff"
    sha256 "9cca169cc830c331ac4246e0e87f5c0b47a85b045c4a0de7cd4999d89d2ab5ce"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    if build.head?
      ENV.append "CFLAGS", "-I/usr/include/uuid"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gupnp-binding-tool", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gupnp-1.0", "-L#{lib}", "-lgupnp-1.0",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.0",
           "-I#{Formula["gssdp"].opt_lib}", "-lgssdp-1.0",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I/usr/include/libxml2",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
