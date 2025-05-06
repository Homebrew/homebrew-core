class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.0/libpeas-2.0.7.tar.xz"
  sha256 "1e9a9d69761d2109eff5b7c11d8c96b4867ccfaca2b921eded49401192769ec9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "ee80bb2b9880d62c908d33623a1829f0a222bb6e402b00234f9deab1c7f0633d"
    sha256 arm64_sonoma:  "a4cd71342b28480f0dbed845598c31042f0e2b5a3f2ffb132319dd4cb9a545fc"
    sha256 arm64_ventura: "9e822ce3fd39ad794fce013f7c980d606d2586228a16d27309c77609e72c7e69"
    sha256 sonoma:        "1459a702efa8caceea393ecabdade57e2cd976c47f06672c115e54e1f8105139"
    sha256 ventura:       "6faa77fc4715669752208ed373a3a4d8605d509aedf50881a6f0e1909304480a"
    sha256 arm64_linux:   "e93ed75627813c964c4ab489dce8f2f2b205f4514c151c90035dd9783c2d12e1"
    sha256 x86_64_linux:  "f3dac6a0f9ba1aa331b51822dc12f11539e92080294ce7c95984add7360cb9d5"
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
