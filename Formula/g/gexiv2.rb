class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.16/gexiv2-0.16.2.tar.xz"
  sha256 "aad9e240fdffbe85e390f46ee0a567e251baea5c29c3d8690260388683dc8d0a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2e204499e2c5020da2f9444a17a74b1f5e54766d488391df23aa434f13759843"
    sha256 cellar: :any, arm64_tahoe:       "b1ead16882a5901c4fce3e577f80a619eb28ee3d118f25055887a1827ba6d255"
    sha256 cellar: :any, arm64_sequoia:     "983259b8361b35ad3b36271e2f700b6501f0a7f8fe321569bc31bf7598a7e143"
    sha256 cellar: :any, arm64_linux:       "6dcef23aeb0616a03eba7718254d8c04f76ebbeb94d9610fefb73c77c7d848f0"
    sha256 cellar: :any, x86_64_linux:      "e69a8f189e0ba658ba6d2f8f06a8e52315643bcc4b0983c9312b4142c39f7c13"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

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
