class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://gitlab.gnome.org/GNOME/gupnp"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.10.tar.xz"
  sha256 "a1ee07b7b12673c32d7fc73ca158a50c1a4dc69ab35b65e94d24d38ac875345e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "963a27df0b3674a9026cfd232c24a87a71e1b40abe4c07d138d2e9a0b76566e6"
    sha256 cellar: :any, arm64_sequoia: "8b1c8656f2c44d74920c0171b3265d3cee54ce4b55a7c59958913cb368f94e1c"
    sha256 cellar: :any, arm64_sonoma:  "3dd3ca5c60dbe71428763577f808d12a39bba5d36af383209faae693be8d3db6"
    sha256 cellar: :any, sonoma:        "5374607b88156b67bef8545b21d0fb29694cbd15988bb611be45862c7a15edb6"
    sha256               arm64_linux:   "a8b37e494619d0d92c7fcd5a4e4d41291d5c84dc10c29b02ccdf66760de990c4"
    sha256               x86_64_linux:  "acacf04f20e9ceea26eb0e95f58f6ba76f6a744b12c5ad49e05d944df1f3a252"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "python@3.14"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    gnupnp_version = version.major_minor.to_s
    gssdp_version = Formula["gssdp"].version.major_minor.to_s

    system bin/"gupnp-binding-tool-#{gnupnp_version}", "--help"
    (testpath/"test.c").write <<~C
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
    C

    libxml2 = if OS.mac?
      "-I#{MacOS.sdk_path}/usr/include/libxml2"
    else
      "-I#{Formula["libxml2"].include}/libxml2"
    end

    system ENV.cc, testpath/"test.c",
           "-I#{include}/gupnp-#{gnupnp_version}",
           "-L#{lib}",
           "-lgupnp-#{gnupnp_version}",
           "-I#{Formula["gssdp"].opt_include}/gssdp-#{gssdp_version}",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-#{gssdp_version}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-3.0",
           libxml2, "-o", testpath/"test"
    system "./test"
  end
end
