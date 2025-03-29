class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.8.tar.xz"
  sha256 "70a003cebd68577293fb3e6af49ff902203bf8768b2fc5d651ddc1f0fa1e11e9"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0d73be784e10b682d081fa15b4779f54cf372468c0ae538d9d1468a135ca460b"
    sha256 cellar: :any, arm64_sonoma:  "c2e208114785c8a6891e62c0372c90a44879f1f03551cf7ea0948acf39aca197"
    sha256 cellar: :any, arm64_ventura: "daf4ba3e00e3c0931a340c6dd4259840deeb0ca477d3f055a48ed517ddf14a25"
    sha256 cellar: :any, sonoma:        "666d7700b2ad4fb6ef4811186eb2b82fce1029e990bb7fecfec1f680c72eb08e"
    sha256 cellar: :any, ventura:       "d73e698c784354e7dcefedda8057a17d3fe4d5274ffc0ce96cce07b441639a12"
    sha256               x86_64_linux:  "6f3b4dbadddd74af18147095bf99055d590bfe0ffce1eca0a4cce2aaf261abb1"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "python@3.13"

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
