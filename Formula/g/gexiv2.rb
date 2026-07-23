class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.16/gexiv2-0.16.1.tar.xz"
  sha256 "18e9a05c637a77e800b001d87f70e4d02a7ba41b7745400a314a1072a1ddc943"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e94acf3838a8fc6100a5e4ecfd4e41c16ad46731790dd16f088caff89c47896"
    sha256 cellar: :any, arm64_sequoia: "0826bedc9623eda5ad91ea694cc1bf9f827a39c6be0eec4cc560f7372ce5e0e5"
    sha256 cellar: :any, arm64_sonoma:  "a5fdd8a8481f2171dcea6b11ddba7f00fbc0d8f1916f7d6ed49b0cd480617543"
    sha256 cellar: :any, sonoma:        "9b309f719756c328df56e07770e91eefa2776c635d8568d3bcb6f74b92296959"
    sha256               arm64_linux:   "4c8437baa2a55bf0737f1e07b4ccdb5b12b67c9813dce850dfc73c4f30cf1557"
    sha256               x86_64_linux:  "bf1d66a4b4aea2dcfbd5a4813191c2739948b8fc838e5c5872f52ede5465990e"
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
