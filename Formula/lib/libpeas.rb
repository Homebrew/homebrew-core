class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.0.tar.xz"
  sha256 "c2887233f084a69fabfc7fa0140d410491863d7050afb28677f9a553b2580ad9"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "14ff01878ee901ba5a2775bb0e144caeb831ef0b8b87d031685a763799cbfc18"
    sha256 arm64_sequoia: "ca49f0fac62ebebbba6d8eefd5917514ba956e285d5210255ff218d4026ab771"
    sha256 arm64_sonoma:  "c7eb04b907a90519d1728914e744f0733881ce7d363776510b5e3fa2ea604c34"
    sha256 sonoma:        "ea6827fdc1357c8cd065520f8cad5c1716b6ed340b3dc139baf14ebc042ac929"
    sha256 arm64_linux:   "48acbb4421f26c5f6e2a6c3bac9988d828a7695b26e2846c1b2838a9ca21e814"
    sha256 x86_64_linux:  "c0162f07daa592c20f4bc01fee54874f482c9199d65c999dda484a97f851ca81"
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
