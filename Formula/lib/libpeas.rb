class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.1.tar.xz"
  sha256 "589eca89b437006edf3755478df037c740a2a84cfa5d202dbad6095e828e2488"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "25e90353ab4047dcdcd86f39a5250782ec85ce114e22ecd8e3f3ac774776c639"
    sha256 arm64_sequoia: "eb3808c00abea9c9940066eef5e74e99e6f5eb6437dde1f77ec05349e9dc2883"
    sha256 arm64_sonoma:  "5ede67a9e6ce599ff4ff84b6e1ea812c855e896b37c18525a3dadc9fd4b499a1"
    sha256 sonoma:        "5f46e154e05f3c81023e0fa73e12a37fe5681dd886341889d0a67fa593d3ca8b"
    sha256 arm64_linux:   "43c8a171cf58ee1a08460b6de1e5c62c6da8b5c9c4637358030bccbdad6db965"
    sha256 x86_64_linux:  "0cc9daa94412c7c78a5538173c5cb2d6ae3b68bff551364e599739bef6db0c9d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gjs"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"
  depends_on "spidermonkey"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.14"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    args = %w[
      -Dlua51=false
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libpeas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libpeas-2").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
