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
    sha256 arm64_tahoe:   "a72b082abb085d326fc3e144815f977d7be22f56e1ea6069f973355517d7cbc4"
    sha256 arm64_sequoia: "c1c8cf6d9c0b5d0b64894d883b0ab62ec28c8ac4d1adbd2055bf4640af7eb4e3"
    sha256 arm64_sonoma:  "31e03f2b631adfaa428c1f387256b64386c6aaee72ac7120a08b84762b6bbdd0"
    sha256 sonoma:        "4aab17c710c1a86ceca29536194de50abd4a44dc2757f3a5911128708ccfc0ea"
    sha256 arm64_linux:   "02b0153cf47f4970d7d7277c3698e69cf41ced94e3f2a2d3a7202d3cf02c7425"
    sha256 x86_64_linux:  "cba275dc7195f4c2537d9d9e7ae6e9f81009d57d29f1da5310e86ac768b3724e"
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
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("python@3.14")/"pkgconfig"

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
