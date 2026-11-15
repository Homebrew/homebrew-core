class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.5/gom-0.5.6.tar.xz"
  sha256 "4d7a5e268698c8e7e40603e36e9e3a2b76133931ce1b637c1136301491b54cc3"
  license "LGPL-2.1-or-later"

  # We use a common regex because gom doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "5bd51f701b73b8146758870182f539e5ad15ef7ed2987fd87006df71bf70b129"
    sha256 cellar: :any, arm64_tahoe:       "0367b23bd13c51fb41cbd7d536488ef34d798321a7d64b6aa4c6a85d9c0661c5"
    sha256 cellar: :any, arm64_sequoia:     "ba98021d67f1f966727723d8f99662c1dfd91326bbbddb712cf8beaaa7d89023"
    sha256 cellar: :any, arm64_linux:       "fea810b0633df96f76a938f43751d21f9c90eaf327e2c069370455621078f3f5"
    sha256 cellar: :any, x86_64_linux:      "a6168f7e7b8e11dd51a8da141408a51ba7c30f22f3860aeb47e4a6094614d946"
  end

  depends_on "gdk-pixbuf" => :build # https://gitlab.gnome.org/GNOME/gom/-/issues/18
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.15" => :build
  depends_on "glib"
  depends_on "sqlite" # indirect dependency via glib

  # Help find `gdk-pixbuf` as superenv doesn't add dependencies of build dependencies
  def gdk_pixbuf_add_pkgconfig_paths!
    deps_set = Set.new
    Formula["gdk-pixbuf"].recursive_dependencies do |_, dep|
      next Dependable::PRUNE if !dep.required? || deps_set.include?(dep)

      deps_set << dep
      dep_f = dep.to_formula
      ENV.append_path "PKG_CONFIG_PATH", dep_f.opt_lib/"pkgconfig" if (dep_f.opt_lib/"pkgconfig").exist?
      ENV.append_path "PKG_CONFIG_PATH", dep_f.opt_share/"pkgconfig" if (dep_f.opt_share/"pkgconfig").exist?
    end
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    gdk_pixbuf_add_pkgconfig_paths!

    system "meson", "setup", "build", "-Dpygobject-override-dir=#{site_packages}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gom-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
