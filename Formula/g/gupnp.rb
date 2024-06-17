class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.6.tar.xz"
  sha256 "c9dc50e8c78b3792d1b0e6c5c5f52c93e9345d3dae2891e311a993a574f5a04f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "015196de1b4d30bf9f813483e62b405b254ffd59f0ada46fc5131743a755b05c"
    sha256 cellar: :any, arm64_ventura:  "15f2967d08d7bb95e3fd9ac8b7eba0aa6c197d64ddd78ece41c454d9cd0754d0"
    sha256 cellar: :any, arm64_monterey: "f6499c492c8347a8f769db41634df06deb88fd2d0f8b0bd9e2e4035d64007640"
    sha256 cellar: :any, sonoma:         "99d916fbba332bb2642a41f1a21961aa9d5d270b3d0bcf605c40db3a9640f1ea"
    sha256 cellar: :any, ventura:        "44565ee4eb34af29dad778fc5f042af5cdf152208f69c0919bed2a2a5a823169"
    sha256 cellar: :any, monterey:       "e95283c0946443b136d9a080e14f1493e3d737a5f2a4de65a5907254f4e0e8e9"
    sha256               x86_64_linux:   "04cf309eee9f3047e8ae8d13a21d58d0e2e9ddd6756a8c29b646d4c5f8cde1ae"
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
  depends_on "python@3.12"

  # Backport fix for libxml 2.12. Remove in the next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gupnp/-/commit/00514fb62ebd341803fa44e26a6482a8c25dbd34.diff"
    sha256 "2b8ead2dc0824bf30dc606421cff3cddc7d8ad785910b1228602bb861601f61c"
  end

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
