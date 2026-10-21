class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.1.tar.xz"
  sha256 "589eca89b437006edf3755478df037c740a2a84cfa5d202dbad6095e828e2488"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "c616b3255f727c1d04dab6475c5d174c148ce7fa8d5b58dec120e36580edd3ee"
    sha256 arm64_tahoe:       "e2992808cb570a6bba919f11fad5e2cf2027bce5495bd92ac22fd51beb0d65c6"
    sha256 arm64_sequoia:     "c925354d393ee085efcda3a350029dbf0b516c2c09be3c528a85e97dd4351fa1"
    sha256 arm64_linux:       "c0a08be5c5fee64d3a97157521cf5eaac73348bbb97c86fede2ff5b37145183c"
    sha256 x86_64_linux:      "fd47c091b58ef63b30860bb64a4fd1e76635fcd112c6c4c0fd4a987e34baaaa7"
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
  depends_on "python@3.15"
  depends_on "spidermonkey"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version python3
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
