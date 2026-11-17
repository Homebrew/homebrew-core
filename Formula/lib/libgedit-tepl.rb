class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-tepl"
  url "https://gitlab.gnome.org/World/gedit/libgedit-tepl/-/archive/6.15.0/libgedit-tepl-6.15.0.tar.bz2"
  sha256 "23126d33b0016e5823351c4845cfdc074f7c232a85288a73d00468d003bebbe1"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-tepl.git", branch: "main"

  bottle do
    sha256               arm64_golden_gate: "5b5e4885d4eb2a754306e1f1f564c629bd19eddec17a48d236bb573bab055470"
    sha256               arm64_tahoe:       "f845f65a33fc4cff6bed23e2bb65a8b20380b7152b202b9d10ef4543d17a09fc"
    sha256               arm64_sequoia:     "f7cea21d25beee0ca848651f3b3f30e84216c06cb800cc48483c3ef648037c7f"
    sha256               arm64_linux:       "1b69da2f20fb591bc212b2b64318200ef76edc60a727f86ed811193bba91ef8c"
    sha256 cellar: :any, x86_64_linux:      "14cb27b1e82ba46c8e27d72866ca206c6c24fe362e4395e024ee8b402716595f"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@79"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libhandy"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    C

    icu4c_dep = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:icu4c) }
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib(icu4c_dep.name)/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
