class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.0/libpeas-2.0.5.tar.xz"
  sha256 "376f2f73d731b54e13ddbab1d91b6382cf6a980524def44df62add15489de6dd"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "ee900a3d6f3a8baa3d73b7496f0d2e5a4be4c0981511a3418e308a5e392cc7db"
    sha256 arm64_sonoma:  "1280c9d9923a7d03bc5b22ef45d2a24b2714d6a3a4a84ce5cde7b514fd99ef3a"
    sha256 arm64_ventura: "3e32ffd64b82bf2e5447eb0faa39b9fbe06d86f9775db67fa5d5b8bfdeadef01"
    sha256 sonoma:        "d296ca5e3fdfd6001a36f4a2243f9d6f1204035ca19487d03794d13089045deb"
    sha256 ventura:       "589b3d1e997e29cf3fb56eb09c9d9ea4ecf82b8166fcc912b4277639312e5ba5"
    sha256 x86_64_linux:  "13d0c3a82abf970b9e289e05292a25199547d5ca8e485226c5767124e7e6541b"
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
  depends_on "python@3.13"
  depends_on "spidermonkey"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.13"
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
