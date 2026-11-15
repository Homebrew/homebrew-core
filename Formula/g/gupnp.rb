class Gupnp < Formula
  include Language::Python::Shebang

  desc "Framework for creating UPnP devices and control points"
  homepage "https://gitlab.gnome.org/GNOME/gupnp"
  url "https://download.gnome.org/sources/gupnp/1.6/gupnp-1.6.10.tar.xz"
  sha256 "a1ee07b7b12673c32d7fc73ca158a50c1a4dc69ab35b65e94d24d38ac875345e"
  license "LGPL-2.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/gupnp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "95b1f52125f9094faca42206523eb85114295ce0c1a74e15291b4bb159087788"
    sha256 cellar: :any, arm64_tahoe:       "35ab6ff76a2f81c5b3f0ebc819cd473c8975f928f33f264f11e453badcfe3d2b"
    sha256 cellar: :any, arm64_sequoia:     "1e0ced1c92b924a60930a47c747e3231e0880a2e06b274ea8b5459415b939cb9"
    sha256 cellar: :any, arm64_linux:       "b9404dd858f2f35a4fb8769756cdcb8a0e27cc18e8e99e27bd3f9dc0ad3cbf45"
    sha256 cellar: :any, x86_64_linux:      "904031b26e94822c708e65dd1b60850eeeae459009a7a582fd691e1171deb556"
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

  uses_from_macos "python"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
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
      "-I#{formula_opt_include("libxml2")}/libxml2"
    end

    system ENV.cc, testpath/"test.c",
           "-I#{include}/gupnp-#{gnupnp_version}",
           "-L#{lib}",
           "-lgupnp-#{gnupnp_version}",
           "-I#{formula_opt_include("gssdp")}/gssdp-#{gssdp_version}",
           "-L#{formula_opt_lib("gssdp")}", "-lgssdp-#{gssdp_version}",
           "-I#{formula_opt_include("glib")}/glib-2.0",
           "-I#{formula_opt_lib("glib")}/glib-2.0/include",
           "-L#{formula_opt_lib("glib")}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{formula_opt_include("libsoup")}/libsoup-3.0",
           libxml2, "-o", testpath/"test"
    system "./test"
  end
end
