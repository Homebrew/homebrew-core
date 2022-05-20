class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.4/gupnp-1.4.3.tar.xz"
  sha256 "14eda777934da2df743d072489933bd9811332b7b5bf41626b8032efb28b33ba"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1937e917519b9784475606a21cc66d5b2ed5914c2008105c992b91a04bee834f"
    sha256 cellar: :any, arm64_big_sur:  "811b1ec251e75dcec1a4f0b885edb3ec50f3b26e27ef0220f2da02bdc19017ff"
    sha256 cellar: :any, monterey:       "56d15f95db673670a3cb899a223bba0b683daa6ddc3c65aadb0a6a85b0a51cef"
    sha256 cellar: :any, big_sur:        "82379629f5708acfbfb767f53e6a0bdfd69ae3a8aeb4b3b747b0c906d7fcda44"
    sha256 cellar: :any, catalina:       "7e2f769606feeb7276facb34f936b547cbabe451dcd76e3428ccf11c03c32f86"
    sha256               x86_64_linux:   "5c70c2506558b48c9457ab89025929328f31333a14afe65d8d96010c7d8ed7f4"
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
      rewrite_shebang detected_python_shebang, *bin.children
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

    libxml2 = if OS.mac?
      "-I#{MacOS.sdk_path}/usr/include/libxml2"
    else
      "-I#{Formula["libxml2"].include}/libxml2"
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
