class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.12/gexiv2-0.12.1.tar.xz"
  sha256 "8aeafd59653ea88f6b78cb03780ee9fd61a2f993070c5f0d0976bed93ac2bd77"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "1f8d42d1bb3e9ca58311b3a08b0576993007cb0d580e8740663e7ad4a055fb52" => :catalina
    sha256 "7d97c40bab30a98f845560e0e6d12ea514ecceee3aab447f9a06664474d2ba10" => :mojave
    sha256 "98515f671493f424a126e54ed940358f87a26d1bb049051735014b7c8a070900" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython3_girdir=#{lib}/python#{pyver}/site-packages/gi/overrides", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
