class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.16/gexiv2-0.16.0.tar.xz"
  sha256 "d96f895f24539f966f577b2bb2489ae84f8232970a8d0c064e4a007474a77bbb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "65daf3be90e7c24d84c131e5eb349d90c935f45ceeed7e043cd083617dfde41a"
    sha256 cellar: :any, arm64_sequoia: "6566b30dffe1e55d2dd899cb609d06567ab05122b320a4135d00485aa5fd23a9"
    sha256 cellar: :any, arm64_sonoma:  "df3ffe2eaf8be10632c018f21857988aed01f71e43d72362870f09306e28a3d5"
    sha256 cellar: :any, sonoma:        "1295da3e261bc8240e05d696103954b4cbefb0b2e14d292d475c9195cd32f565"
    sha256               arm64_linux:   "94cc5f0acb7cae5223e9bca62fcd96166065faa9c7300335fcb0b7ea0d9a5db7"
    sha256               x86_64_linux:  "6fa18288dad24d85cabc1725bdd570a9452cd59497606e698c2730e543e0c960"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
