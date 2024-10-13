class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.3.tar.xz"
  sha256 "21e64d2c56e9b333d44fef3f2a4b25653d922c419acd972fa96fab695217e2c8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "5c0359ddfb69810924b8987d62a9e353455b76e4ee4c4739736764f1d45aa7c1"
    sha256 cellar: :any, arm64_sonoma:   "67e11e557d79c924eddda15dbca08e388946bf1f8d4ccb60e938901719f3c579"
    sha256 cellar: :any, arm64_ventura:  "afda771f7cb34bcdccda695f5b843d1acd188427e8b0dcb55e895f427efb515e"
    sha256 cellar: :any, arm64_monterey: "daef02de6a9fd13965b53543ecb568dbdfcccb69a9425f047fff2ae4bc28e457"
    sha256 cellar: :any, sonoma:         "15453b28ad8ceae545a5fd10ba90075b191a87945da03ccfc4fd64a43433f886"
    sha256 cellar: :any, ventura:        "fe5fa4ebfd93ac04ac0abf3e8aaa151312c4e6b4f33f2ed4e162d5617bbd6215"
    sha256 cellar: :any, monterey:       "d8309f1187652152e7817e0973e6496e3ddedf549eb279c1704523ddd81c0e2a"
    sha256               x86_64_linux:   "93e44d86332a71710f2e67fdc510541988bb8794493a735ac26a7c933c58e916"
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
