class LibpeasAT1 < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.38/libpeas-1.38.1.tar.xz"
  sha256 "e82fd328adcac1aba34b64136bdfcbbacf2b3258a8bc4e5f480a72502a611ae9"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/libpeas[._-]v?(1\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "03fc4c7a900b9c2d06f7bc7d36f6a657693caeb1fd9fdcddc50bf0911f4cce69"
    sha256 arm64_tahoe:       "eeb58aeab4af7fbd4ca2202fecd5e51a456689d9f4d1c96b8d76e277802f1025"
    sha256 arm64_sequoia:     "f492e286d623b5069e567e2e873d07cad9a0375f9ecc899bb9848b36eec15e8a"
    sha256 arm64_linux:       "ed40fea503c21d95e1119af6ef14f237a449d808633374938b5fe2b2fa257ddb"
    sha256 x86_64_linux:      "b404b8d15b6146786c34fa67954528176f7275b6f3dce36204785da045cdbbb8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.15"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    # ensure Meson uses homebrew python
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("python@#{pyver}")/"pkgconfig"

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
