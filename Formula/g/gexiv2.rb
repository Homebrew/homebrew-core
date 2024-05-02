class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.2.tar.xz"
  sha256 "2a0c9cf48fbe8b3435008866ffd40b8eddb0667d2212b42396fdf688e93ce0be"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "c80f38f7bc014d4b17196583ed6d1de648e5000e52663f8d00f95341d26cba60"
    sha256 cellar: :any, arm64_ventura:  "612684a73317a22620479756fcee11fae7fd1436446b087edff24385df11eed2"
    sha256 cellar: :any, arm64_monterey: "469e0ea99ac26cf6fb64feecd2bb2b5a96f8e2e4d3db4eebd409c4a7ff9cef3b"
    sha256 cellar: :any, sonoma:         "853e45314b2824c293a4124245ffac4773b7ef79653be1c77fa47372b8e1c8fd"
    sha256 cellar: :any, ventura:        "8765986471baf740607e563c7b99eb3a447fb4ff3b51557ea6e652705d3b1c7b"
    sha256 cellar: :any, monterey:       "26bcd41689a5be13d78bd78a1728448ac6114cb3b63ad4fb6e03aa517cde7594"
    sha256               x86_64_linux:   "f940fee4151e253561119242611886f248a6a6ef1c21813d0a91c9872e5762cc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygobject3" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def python3
    "python3.12"
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
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
                   "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
                   "-L#{lib}",
                   "-lgexiv2"
    system "./test"

    (testpath/"test.py").write <<~EOS
      import gi
      gi.require_version('GExiv2', '0.10')
      from gi.repository import GExiv2
      exif = GExiv2.Metadata('#{test_fixtures("test.jpg")}')
      print(exif.try_get_gps_info())
    EOS
    assert_equal "(longitude=0.0, latitude=0.0, altitude=0.0)\n", shell_output("#{python3} test.py")
  end
end
