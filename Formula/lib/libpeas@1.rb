class LibpeasAT1 < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "a7a811d4a2fe22ee7f65b6e5c72d77a9d4bbd9bbc2f1f2b799484695671447fa"
    sha256 arm64_sonoma:  "ca08be169114c264356fc1556108c1bb42c326990bbd2bd3e68eb03b751c50db"
    sha256 arm64_ventura: "706a31d9b99a1092ac5a93f71f3faeb1f23c6e4a6e9976a8e5c57e37dc6a5a4a"
    sha256 sonoma:        "e3668a9bfe2c95576190265ba214ed90c928d5e7965f6bf75fe68fbfdd21d953"
    sha256 ventura:       "46fe7102d129d7c31095ffcfe391317576295b2b4d43f44c0cd7c31e37616392"
    sha256 arm64_linux:   "14fb239a9356dca2cdec0c5468272ea40b66047ae82a6d00fa104a5f8a0332ab"
    sha256 x86_64_linux:  "64df87ebec61741b04d81e290758550ea317811584c413b29510396fe4cd19b5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.13"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    # ensure Meson uses homebrew python@3.13
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["python@3.13"].opt_lib/"pkgconfig"

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
