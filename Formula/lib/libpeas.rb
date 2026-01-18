class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.0.tar.xz"
  sha256 "c2887233f084a69fabfc7fa0140d410491863d7050afb28677f9a553b2580ad9"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "234838eddd571c1d7efdd5868882c2d80e6764e59b03dae0debabf27f0a5932a"
    sha256 arm64_sequoia: "570eabcca2b4189b555c5c0e62a07a45970dcf35be48dcff428821c675e4295c"
    sha256 arm64_sonoma:  "adaf6171ede05a19dc1bdb5afbe47f87ed3e6c609fac76d75988d6bc4ab8e21e"
    sha256 sonoma:        "39cf919406133f754692fe9d0a37442e670031f18d58096175c973dc566dcf0a"
    sha256 arm64_linux:   "5ccbaf3a166e6eaef53c9eef508870be08f0fdc25522efc31edbb8c5d5ae15b2"
    sha256 x86_64_linux:  "6afc2f21005f3683a823bdd29638e2f36d687dd48f78868150bc94e2728fe569"
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
