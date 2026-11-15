class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/2.2/libpeas-2.2.1.tar.xz"
  sha256 "589eca89b437006edf3755478df037c740a2a84cfa5d202dbad6095e828e2488"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "89673f946c510b1d959d2e20212461961f7ffd76e070d3b45e7a2bf6b4053a3d"
    sha256 arm64_tahoe:       "9441f8a9568cbfc562b0c65e9a4ecb88cac6e9cb6335e4896c608d80cfdb9704"
    sha256 arm64_sequoia:     "3ce3c7be74bcfc806d5fbad7cd6a9782c59744c48d6847a97b35fcf453d11eed"
    sha256 arm64_linux:       "bbc7d25e0ca0eb92277e334d2ef1dc80fccbf292bd7ff1d502c1e33c11ee06bd"
    sha256 x86_64_linux:      "1e0b06e97a4c7aab7498bb8f3ea852a57203e2f95f31bf45d28fb18e88351dd4"
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
  depends_on "spidermonkey@140"

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
