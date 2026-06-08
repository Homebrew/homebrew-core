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
    sha256 cellar: :any, arm64_tahoe:   "511ed8f353a51336ea55364d8cd3fd626ecb5f6d04f91d7cfc0c23be3b0fb04b"
    sha256 cellar: :any, arm64_sequoia: "4c93590b5956c317a7d2bc6a38aede4e0c047c9925e967ebc7884a6f4b77dbbc"
    sha256 cellar: :any, arm64_sonoma:  "ea9dc8fd99c38aff11dd81cb0eebae01044ad73b6a6cffc4f117726edbf50ba0"
    sha256 cellar: :any, sonoma:        "d560aa062fcbb20f4a5085682fa3f862b6dca8c30eb21b562418e7e83965634c"
    sha256               arm64_linux:   "c1131eafb65f0da08a9e3d1d63ff1b00e9caaf801bbd1ed5ce94f6d3b840c79d"
    sha256               x86_64_linux:  "028268f8e15073088bd20359757d2436a43e0b018d07f44b9ff3d25c6a6eeacc"
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
      Dependency.prune if !dep.required? || deps_set.include?(dep)

      dep_f = dep.to_formula
      ENV.append_path "PKG_CONFIG_PATH", dep_f.opt_lib/"pkgconfig" if (dep_f.opt_lib/"pkgconfig").exist?
      ENV.append_path "PKG_CONFIG_PATH", dep_f.opt_share/"pkgconfig" if (dep_f.opt_share/"pkgconfig").exist?
    end
  end

  def install
    site_packages = prefix/Language::Python.site_packages("python3.14")
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
