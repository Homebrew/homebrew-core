class LibpeasAT1 < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "6ae295b72edb4f0aab90390ee118cd2864f9ef7cb57b3f318341663c0eaad4d6"
    sha256 arm64_sequoia: "0d7a24fa0a9dc00416ac677f708addc5ea6354063c27b8435dee4744367fbcb2"
    sha256 arm64_sonoma:  "d3c58402100eae7994d0a510a8ef9ac00201d3c8077356034b351ab61454a126"
    sha256 sonoma:        "c7fcf4479a9de9332df0b79885f77439b8bc9d855fb897309ee0de01b4890d3e"
    sha256 arm64_linux:   "983fb2f22bcc97d2c814e53251b0fd2027898eeae80ce22a1d04527e507f6459"
    sha256 x86_64_linux:  "bbc312a0e2b0510a2cf0a7fec5ff551f8b845958ad7bcbac1a59c85a5933cefd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.14"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    # ensure Meson uses homebrew python@3.14
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["python@3.14"].opt_lib/"pkgconfig"

    args = %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libpeas-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
