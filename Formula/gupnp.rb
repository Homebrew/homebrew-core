class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.2/gupnp-1.2.4.tar.xz"
  sha256 "f7a0307ea51f5e44d1b832f493dd9045444a3a4e211ef85dfd9aa5dd6eaea7d1"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "054503ec95766bbf5ef2fa8b15415898b2386d0659417cade2d615cf635235b3" => :catalina
    sha256 "7cb92f536e1c498df40267f173322451c4afa631ed364c0d99d7eade7bc73756" => :mojave
    sha256 "a691fa65b88e39d8b09b87f68890436d0848fbf6f0ab2423fc417b9e46a0fff8" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"
  depends_on "python@3.8"

  def install
    mkdir "build" do
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
      bin.find { |f| rewrite_shebang detected_python_shebang, f }
    end
  end

  test do
    system bin/"gupnp-binding-tool-1.2", "--help"
    (testpath/"test.c").write <<~EOS
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gupnp-1.2", "-L#{lib}", "-lgupnp-1.2",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.2",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-1.2",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I#{MacOS.sdk_path}/usr/include/libxml2",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
