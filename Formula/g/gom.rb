class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.5/gom-0.5.5.tar.xz"
  sha256 "ad61f05af2317a7ab1771fcfa816989fbba3b18957d2e0b5dede9ef45f09b534"
  license "LGPL-2.1-or-later"

  # We use a common regex because gom doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "52a58d24dad257ba7321f42acd30b67c6aac05a7efe5b9d3fb8b1b76657808e4"
    sha256 cellar: :any, arm64_sequoia: "e9241ed6619c79c2cebe1b5508672aec223f464dbc7f1ab29e1e49151a1fe942"
    sha256 cellar: :any, arm64_sonoma:  "772d157dfb130510e77b4499c4a6d31b77f3883e699b5c48576f53fc99019954"
    sha256 cellar: :any, sonoma:        "d6c9b90b0ea895edc45d71215c52e078c01ec924843a9594d0252139bfe03ab9"
    sha256               arm64_linux:   "2b147cf4c58a9dd1297191fa92a99b93e5245ba9102ea22c287d49f5ccf56b97"
    sha256               x86_64_linux:  "469ff80ce89cc419eef6768b5672d25f8f3c557d269d02f0e2554f784da92a47"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "sqlite" # indirect dependency via glib

  def install
    site_packages = prefix/Language::Python.site_packages("python3.14")

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
