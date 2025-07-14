class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.9.tar.xz"
  sha256 "2edb6ee3613558e62f538735368aee27151b7e09d4e2e2c51606833da801869b"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "30d6c15e0e67e5f4bfbbffbe5c51376955d296985ee96114f2abbf0316dd04aa"
    sha256 cellar: :any, arm64_sonoma:  "1830346216a09586177fc3a496373fb8010334893553e0f337885bf18f796c23"
    sha256 cellar: :any, arm64_ventura: "f046d7600a8bb320134a022c9f3e21ce5435890a1e5a634dad970fb3467548a6"
    sha256 cellar: :any, sonoma:        "76f7a83431dbe7d15b2fa5996a23e5781344e5d62284005631373b6513217c05"
    sha256 cellar: :any, ventura:       "c6f43169fffb45b8934f1b88848453e6612704612b24d08eb7a2d3c5d2054264"
    sha256               arm64_linux:   "af6ffd8565531bfe5989e206e91a4546dad7991304ec7f46600b7f971ea0bd75"
    sha256               x86_64_linux:  "81e328bd58cc0d5e6d6797134d64c5abe64bbb58829eb337d08f625d6bf65c87"
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
