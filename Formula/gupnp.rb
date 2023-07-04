class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.4.tar.xz"
  sha256 "d6c3d03583844fa52abe003043186007f0c84145fe3b00fab25995beda9be55a"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "dad63e0d4c8c7e76e0ac7dc05823ab02f7aa1bfaa9636712b6c76da949340eee"
    sha256 cellar: :any, arm64_monterey: "6c9bf0b9f82627ebb5b5462b53f93e3be2f873faaef74d36021406afdcecfae1"
    sha256 cellar: :any, arm64_big_sur:  "9b0e71d05048d7242292ec3f01a37b4be918bb71f0788cb8d752afac49b57a31"
    sha256 cellar: :any, ventura:        "750136d45ab30c17c4ce40922488aaafc1e92e70dba7ada59ca387215be043d5"
    sha256 cellar: :any, monterey:       "603656ee673fd08f482669b363997c4d0fd5147fa3ad70af801c8602a5bdf884"
    sha256 cellar: :any, big_sur:        "760f75566fe0add84c79fc7ff6f67738f675a13fd1cb64e99ec29b8c6a732f67"
    sha256               x86_64_linux:   "c3902cc8320db2e78f87e5663cbdab588619b54dd4e7c3be713c130c6f9886c1"
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
