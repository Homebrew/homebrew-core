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
    sha256               arm64_golden_gate: "55073b538c7d7af26d425954453c9588e22840aa46608c7c7443eb5f28f081e8"
    sha256               arm64_tahoe:       "3d42f2d023742cdca8ee02b75c86694029dc3183c2a406548b66f144ddf64046"
    sha256               arm64_sequoia:     "af09bfea0637b219cd0ebe900c91685118c6387b8c6a23065940fde0a66241eb"
    sha256               arm64_linux:       "0e4d7db7b75f5e98e783c840273ae79900e1f9eb3809a8d06b47e0e9dd9c62b1"
    sha256 cellar: :any, x86_64_linux:      "46332b8a29f224d06c83428ebafbe5f6fdb9765b819467fab89368738b6b1349"
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
