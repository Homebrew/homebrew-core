class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.5.tar.xz"
  sha256 "0913c53daabab1f1ab586afd55bb55370796f2b8abcc6e37640ab7704ad99ce1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e144b2db6f88e9d2e7c711935b0d5a953d926fcabf7b583ac5777d9d39e3c1e8"
    sha256 cellar: :any, arm64_sonoma:  "fc1bf57619e3ca0b3354da1a412c06ff5ff8774082ec4d7eb53831d324d1ce35"
    sha256 cellar: :any, arm64_ventura: "fc6939bf7c584ee6fa3c937a953ff893031846a6a74228428738dcbc76cf1869"
    sha256 cellar: :any, sonoma:        "d942a0a277ee578fd37fcef24cb01889993677e5557f280111ab791c995a60bb"
    sha256 cellar: :any, ventura:       "ee7209969f482ae2a0fd00e0a462a34ed1a8748c6ea845e4434b99ae97729780"
    sha256               arm64_linux:   "6d937d19f494e9f914a9e7b9beb4aaf1cd59057532650b340b43228d7cda7f03"
    sha256               x86_64_linux:  "22177519ec2e883557c1b91c4fcb8962ea8564f5cc00e38025da3195e6684221"
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
