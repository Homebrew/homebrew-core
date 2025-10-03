class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.5/gom-0.5.4.tar.xz"
  sha256 "57ba806fe080a937d5664178d21bad7653b2c561ea128187a7b10bc1762b7f65"
  license "LGPL-2.1-or-later"

  # We use a common regex because gom doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac68b886f3936f558ee1a6f7023bf6789fa4479806011d55cbcde1f3f530dc24"
    sha256 cellar: :any, arm64_sequoia: "286804e2a0f7f463371deb3b386ea5943a2546725f730d9023b1c8ef94b58229"
    sha256 cellar: :any, arm64_sonoma:  "a1da7b8efd1e81f0e2042e6b6ab12ae7ee6d59078b618f9084646cfa813e8077"
    sha256 cellar: :any, arm64_ventura: "8710fd832106faaf1887b3a6c13959cd42879f780fe2173c798d50a675f0cfc7"
    sha256 cellar: :any, sonoma:        "4355ac5f7df2cecbf3c4f08ddbb993a8452f1919d1c06f2de625b4afac9bf658"
    sha256 cellar: :any, ventura:       "f91f8be1c52a4af4c309591d915fe0a78909255466255e3d913d0dbe535f37d6"
    sha256               arm64_linux:   "c0aae5f129a2a49b67386a4bce25ad16758c54e9db383da740a51c6b954f388e"
    sha256               x86_64_linux:  "682a80579b541d47fd4e224e9c4d03d2bdd73d436fcba5c0877898bdaa38c185"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "sqlite" # indirect dependency via glib

  def install
    site_packages = prefix/Language::Python.site_packages("python3.13")

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
