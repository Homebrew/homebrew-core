class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.5.tar.xz"
  sha256 "437dff970142e8407087a89855f717e20d27c9d76e05b4cd517df621c7d888cd"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e6ee5368a0c33eab4032d7d34dc82c78a072dd5767cac9b4c2423a0a850302a6"
    sha256 cellar: :any, arm64_ventura:  "fef28e8b65542025e4758d4ff4ad85e50dfff492e1421ea2e612211174093cb7"
    sha256 cellar: :any, arm64_monterey: "eec2372a8db3fb0d68d66e740db85b4589d63814d65eeda74870790825bdc7b2"
    sha256 cellar: :any, arm64_big_sur:  "637c1f9909de8a9fdb6095ab7e114f973039803523389b218da1f4faee2482e4"
    sha256 cellar: :any, sonoma:         "f9069b0ceabb2a670a7ec7c0a72ee9e210e0ca2b0db213d082534ee0ac220771"
    sha256 cellar: :any, ventura:        "f4ace8c0c53b34b582a37323df1b4b813e605031ac7a898d2f8ff6388021b4d8"
    sha256 cellar: :any, monterey:       "adeba1418919f58162de30c1bb6b74ed06a48ecc53363e5254c4054ae608770f"
    sha256 cellar: :any, big_sur:        "da88d6e7d2da07422fea4cdcc4b2f4475281018ee959bb969b08527644f89258"
    sha256               x86_64_linux:   "1c9e8e93453993b8560273ba0e1903074ae2a354c37f687e441ad44e486e6113"
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
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "python@3.11"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    gnupnp_version = version.major_minor.to_s
    gssdp_version = Formula["gssdp"].version.major_minor.to_s

    system bin/"gupnp-binding-tool-#{gnupnp_version}", "--help"
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
