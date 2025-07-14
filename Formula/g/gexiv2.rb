class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.6.tar.xz"
  sha256 "606c28aaae7b1f3ef5c8eabe5e7dffd7c5a1c866d25b7671fb847fe287a72b8b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b0be40f4352e5bac318259440594e2ca16a81b376348a800bfcfac353547b7c0"
    sha256 cellar: :any, arm64_sonoma:  "d2a54167e5c765ff57d453313dd3b13517c9f92312af73cdf72be9329a6cea12"
    sha256 cellar: :any, arm64_ventura: "7789b5180180ea16b5356d756c19b908271dec072c79a80565ba8963a6b2194a"
    sha256 cellar: :any, sonoma:        "4a70e5aec83a5c3ea6b06cf1e78fa6328bb6ea839fb6d827061dde2d2ef72d10"
    sha256 cellar: :any, ventura:       "8e378af8cb103ebf8fa406f4f0af5e3279e7df9c77b63c941d9c38cb43ae6dfc"
    sha256               arm64_linux:   "cb683ac05d80a629b5b5dbbe828435f2782cbf5d2fdb7eac71f7d164fe3882fe"
    sha256               x86_64_linux:  "e50cb89c508f33ab907a6e531ccb93727ad126509bb3098d9acce22002c79863"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pygobject3" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def python3
    "python3.13"
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

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
                   "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
                   "-L#{lib}",
                   "-lgexiv2"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import gi
      gi.require_version('GExiv2', '0.10')
      from gi.repository import GExiv2
      exif = GExiv2.Metadata('#{test_fixtures("test.jpg")}')
      print(exif.try_get_gps_info())
    PYTHON
    assert_equal "(longitude=0.0, latitude=0.0, altitude=0.0)\n", shell_output("#{python3} test.py")
  end
end
