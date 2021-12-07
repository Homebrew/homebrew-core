class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.4/gupnp-1.4.1.tar.xz"
  sha256 "899196b5e66f03b8e25f046a7a658cd2a6851becb83f2d55345ab3281655dc0c"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "7ea38b22cda285c7d2faae5ab7aad90115cc3e1a230f5a56b804b5f4e58f5393"
    sha256 cellar: :any, monterey:      "e928003c57d8a36534c56b9ed3a96c9e0f98f4a4a4570adbccb759d4714ec93c"
    sha256 cellar: :any, big_sur:       "fd8883416f1de59ab46c792571554847f1285d3a5c27c893084c56b18170fba6"
    sha256 cellar: :any, catalina:      "e499f57ec7abb5f9e0b88db49d381edf5ade005b71e730aee4d32efc29eb18d9"
    sha256               x86_64_linux:  "b34977852d61556b06fa2a2d8067df3ffa6fe11fbb1fb90e1745208f0b98a3bc"
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
