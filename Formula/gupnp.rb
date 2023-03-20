class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.3.tar.xz"
  sha256 "4f4f418b07b81164df1f7ab612e28e4c016c2d085b8a4f39f97945f8b15ee248"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b652cdd6223938ab72b4038a5c28c8dda25b20cc3cf59448aa3f0fad746e0c8f"
    sha256 cellar: :any, arm64_monterey: "0b537680ffef717b00269d7d3bb6afdcbc63c7e8b38f40838f0de007cc5105bc"
    sha256 cellar: :any, arm64_big_sur:  "a7f308ab85804a43457a35d75b6453c51781081d2333cc0f6db04247c1efadd1"
    sha256 cellar: :any, ventura:        "0c6deea33cde2156fbb71291fe1a8aede21b779e9fb6607908dd866deab72571"
    sha256 cellar: :any, monterey:       "88aa8d9031cd934b2a7109a160466090bcefe4f6a267d194d309b020566853da"
    sha256 cellar: :any, big_sur:        "8de88ea5e2ba6ec105319ede1d78fcb9b44c8b1a4488bff8cbd3ef810da5f7ed"
    sha256               x86_64_linux:   "50827d1577c1f06be8f5b1424ba1fc1401960192f3ab08565f095da83a0e5a12"
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
