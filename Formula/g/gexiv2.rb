class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.16/gexiv2-0.16.2.tar.xz"
  sha256 "aad9e240fdffbe85e390f46ee0a567e251baea5c29c3d8690260388683dc8d0a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a77214ac1ef891b0c618cb7035823ee8eee2e91761620176b92bfd0733abc9e0"
    sha256 cellar: :any, arm64_sequoia: "fc96598da3ca91ef05c004dda94b62a4b12675cff1a631d0dfb775823bcaf080"
    sha256 cellar: :any, arm64_sonoma:  "d0ba02ae08419f39324684ac5678e2c791d308591a8d9b9af54969ed751607a3"
    sha256 cellar: :any, sonoma:        "db9b422562e9d8041a63ea305cf93dfc3fe7f2456caa1f5313456ae012396758"
    sha256               arm64_linux:   "23628e31be56d8d63d8cca6a3fd343e5106a43ddae8605f8dfad854a48d2e35e"
    sha256               x86_64_linux:  "fecb00195dc793205fc06742f040dc2492efc29eaefa1a29d08143c98da57909"
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
