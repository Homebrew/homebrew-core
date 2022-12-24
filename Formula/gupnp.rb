class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.3.tar.xz"
  sha256 "4f4f418b07b81164df1f7ab612e28e4c016c2d085b8a4f39f97945f8b15ee248"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "81898c6f9183f8a141769c6aadd63f8835ab7dbb9a3fca0145b0862f4d4af04c"
    sha256 cellar: :any, arm64_monterey: "7124e700f0f5f5ba2ea1d8b5666dd14738419a0a5476ac04a5de4a0eebf05290"
    sha256 cellar: :any, arm64_big_sur:  "70b42ccefc7c188fa66a9d8fec99c64db4269e6a3364d765b778be23efa2d368"
    sha256 cellar: :any, ventura:        "9288f119efbbe36f19bd6462e0acd10dfd9e1dc1fb92019742d6af2f00a73b50"
    sha256 cellar: :any, monterey:       "4f0b3dbfd0daf7822f822958336f4e02d4c08983754294084edfac0da4927a35"
    sha256 cellar: :any, big_sur:        "cd0880e2a66e5984f0d9a10bc76d2112bc23feeb250afd8f1d4bab3579f7dfdb"
    sha256               x86_64_linux:   "6014f70bdae037603987199b6182a7fb70cdfa0184ed3c1a46f5c6a607cbf926"
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
