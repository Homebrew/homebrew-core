class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.5/gom-0.5.3.tar.xz"
  sha256 "069d0909fbdc6b4d27edf7a879366194e3ab508b03548bf5b89ff63546d20177"
  license "LGPL-2.1-or-later"

  # We use a common regex because gom doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "653c39bbf08707dc8fc4204ce7b2317ff5304cf9050910df166292b34b68abdc"
    sha256 cellar: :any, arm64_sonoma:  "5a91a0b28b4eb4621c687882d85be9d61fb9055affb380a9975ea884bbc56956"
    sha256 cellar: :any, arm64_ventura: "ce76f0563174a6410e3352dab6eaaa91be8a88cce5daf7e6595397631d5da76d"
    sha256 cellar: :any, sonoma:        "1018395f8e1ec4725a0bc5484871d0648f543bcf1c5c3bfd2587b0c00e9c9bc2"
    sha256 cellar: :any, ventura:       "d6e41c8ef3f8f84204e1f368e7af8734b1243b75d069c6e7b3266f656d03fc15"
    sha256               arm64_linux:   "7f79d6810958568ec1e2c7ad7d93b404c148ce0d4a41cf83647c263b1c5750f2"
    sha256               x86_64_linux:  "0121f2c07b7e91f5b2fc56bc19d034e604540c927efe6e3fa2a28acfc707c66c"
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
