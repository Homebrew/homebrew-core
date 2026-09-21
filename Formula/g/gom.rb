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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ecb897fa8aaac867d2e94bde956f9ecaf66dd82a235e90bfc8df4cbc4b311193"
    sha256 cellar: :any, arm64_tahoe:       "b1a06c108f5d6825a633479cbfafaeb84b782489daf60a6e82e255a1b8870672"
    sha256 cellar: :any, arm64_sequoia:     "5545021b60c1d4c427fa27a311d7b4800eed86b3c328534cd7ef7c6f354ea83b"
    sha256 cellar: :any, arm64_linux:       "ec9e7993c9b8320781af9435430cce0ed594dd55d23e7e5ed5f90532f86011ba"
    sha256 cellar: :any, x86_64_linux:      "3d6903358a8e8471eb52e99c18f20ea4c2a2792e449270e0769450970c6e7274"
  end

  depends_on "gdk-pixbuf" => :build # https://gitlab.gnome.org/GNOME/gom/-/issues/18
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
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
