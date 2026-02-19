class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.16/gexiv2-0.16.0.tar.xz"
  sha256 "d96f895f24539f966f577b2bb2489ae84f8232970a8d0c064e4a007474a77bbb"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "24d603085d106cc7d08e199642d858d2b962ffa9e38c40ee4b23bf9953efeeee"
    sha256 cellar: :any, arm64_sequoia: "0c2696669b2614cbd240188c86a6e45db6ec4e9d672382ae39723f1bb4afb59f"
    sha256 cellar: :any, arm64_sonoma:  "26e318f39f877307501fc0f7106a8c5541d0e3d6f3bb4761ce3bab0cf76b5221"
    sha256 cellar: :any, sonoma:        "0a21ff17505b6557231bad21b09a6aaf47e249aa18c1983018a3620fa73cb923"
    sha256               arm64_linux:   "6f720afb3387da506741f5c2bd998feefc0b208b4c280e5181b0c2f2f768690f"
    sha256               x86_64_linux:  "d1a0c6ea1f0c31654fa2aa67ec016dc93ae6b19cab16866c72452400111102f1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def python3
    "python3.14"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)

    # Update to use c++17 when `exiv2` is updated to use c++17
    system "meson", "setup", "build", "-Dcpp_std=c++11",
                                      "-Dpython.platlibdir=#{site_packages}",
                                      "-Dpython.purelibdir=#{site_packages}",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    C

    flags = shell_output("pkg-config --cflags --libs gexiv2-#{version.major_minor}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import gi
      gi.require_version('GExiv2', '#{version.major_minor}')
      from gi.repository import GExiv2
      exif = GExiv2.Metadata('#{test_fixtures("test.jpg")}')
      print(exif.try_get_gps_info())
    PYTHON
    assert_equal "(longitude=0.0, latitude=0.0, altitude=0.0)\n", shell_output("#{python3} test.py")
  end
end
