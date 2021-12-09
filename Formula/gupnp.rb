class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.4/gupnp-1.4.1.tar.xz"
  sha256 "899196b5e66f03b8e25f046a7a658cd2a6851becb83f2d55345ab3281655dc0c"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9b270d05df62f6bb354888d53059f287934a7cb1db49d95314554737786ecc10"
    sha256 cellar: :any, monterey:      "d0e643180b88c91bab346be63fe5c6704133b78d7466542e0bfc4a2aa26d02c6"
    sha256 cellar: :any, big_sur:       "eea3bf0a0fdc4acd29c2ad0dd52ae961511fdd481da10d020ad1a6f491d5e89b"
    sha256 cellar: :any, catalina:      "5c50ff780df02b5770ceeafc4425eb697c2ed4d1e11ec5f69af38d498436f8b4"
    sha256               x86_64_linux:  "10b763c702998b668f8b44a58b9a76015ec72f2c35533525390af4f95e0fcbe1"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup@2"
  depends_on "libxml2"
  depends_on "python@3.9"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

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

    libxml2 = "-I#{MacOS.sdk_path}/usr/include/libxml2"
    on_linux do
      libxml2 = "-I#{Formula["libxml2"].include}/libxml2"
    end

    system ENV.cc, testpath/"test.c", "-I#{include}/gupnp-1.2", "-L#{lib}", "-lgupnp-1.2",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.2",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-1.2",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup@2"].opt_include}/libsoup-2.4",
           libxml2, "-o", testpath/"test"
    system "./test"
  end
end
