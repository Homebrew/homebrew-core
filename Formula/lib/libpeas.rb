class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.0.tar.xz"
  sha256 "c2887233f084a69fabfc7fa0140d410491863d7050afb28677f9a553b2580ad9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "89faf4687f9d846c884aa2158c86e99a70b56b81c7119979e757833955ef8c6e"
    sha256 arm64_sequoia: "62c9bee04b73e39a6cbc4c863e2dd2f9d80cf8daee4c0e12934de9ee48ea6b56"
    sha256 arm64_sonoma:  "bc20458f8a32e06cb66b8281dc7b6893a73dd1ca20cad3f2e377954842f68c00"
    sha256 sonoma:        "73e31e27dd9f0ae87ed1dc1a71ad608c0fce5c1256de6ecc140573ecf8e9fdc2"
    sha256 arm64_linux:   "917a550712a770ee027117b97af9709008ba7a65893ae50239af51018f85d8e4"
    sha256 x86_64_linux:  "5fc1a8bc9da800d2295294b8fe82d30e6802f82093fe42b2c77c066d7012698f"
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
