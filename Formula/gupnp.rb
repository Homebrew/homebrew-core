class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.4/gupnp-1.4.0.tar.xz"
  sha256 "590ffb02b84da2a1aec68fd534bc40af1b37dd3f6223f9d1577fc48ab48be36f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "189d75ec84ee768b7788a884231ddaec044b2af8693cc57c6555b94ee34f320a"
    sha256 cellar: :any, big_sur:       "af46ddf4a8872d6a181a4e71e2667ff3d2a9d99f15123d44c330b3dcce9a9ab0"
    sha256 cellar: :any, catalina:      "2f4cde6e0b70a5bbfe8e32ed284b22499f05ed5d8b7e230af50a9b0ed6ce7c52"
    sha256 cellar: :any, mojave:        "35c75d08d5898cc3477a118598d9439c3e717885ff6c351206a754456458e1e1"
    sha256               x86_64_linux:  "a95c5f0a9c64e3f64d6837ced1d8693fbd687de0d115b14d3a89efddb0528cfb"
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
  depends_on "python@3.9"

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
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           libxml2, "-o", testpath/"test"
    system "./test"
  end
end
