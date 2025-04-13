class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.3.tar.xz"
  sha256 "21e64d2c56e9b333d44fef3f2a4b25653d922c419acd972fa96fab695217e2c8"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "cd712760b3f1d290f1fc59262907b5298c8e09fed1d96c638772f7db1514deea"
    sha256 cellar: :any, arm64_sonoma:  "8c483d386a059aae6e431a91beeedd90487d8c74c8f137353f2de8669da6ad6f"
    sha256 cellar: :any, arm64_ventura: "a4ebe3eef9a3a532bbf91b1a13a22ce8ad9f879937e64531744ec81cc284fdbe"
    sha256 cellar: :any, sonoma:        "1d018abfa68800c473dfd4256ef98a5432258192728bb21fa8c763e6eef2cd9a"
    sha256 cellar: :any, ventura:       "026636430ab1d62ff0b97fc642c7e7986cfb0a82cbc6a56a4efef5c3ec6e3217"
    sha256               arm64_linux:   "96d115b0ff0f7caf635689b009a7850107fca77ef6c3a27122688db0b6e88f61"
    sha256               x86_64_linux:  "b3ddc92c83707fc4ef16912a47bf8cdf01dbf76dd39b91155d1f7c334718c50a"
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
