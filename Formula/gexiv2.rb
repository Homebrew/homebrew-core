class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.10.tar.xz"
  sha256 "7d9ad7147ab51ab691edf043c44a0a44de4088c48a12d9c23c26939710e66ce1"
  revision 1

  bottle do
    sha256 "fe84ae4a9d7b25bc6581afc84b05e2c240f37447918cd0c2de1aecd2df9cd62a" => :mojave
    sha256 "9184a5da5d2ecc05237f285f9d8b0b20e3b3627b70015623cfdd936cc7db1b26" => :high_sierra
    sha256 "704e8fa9a03a6cb7ab6a1a8f15ae9d8041af1f5f5f86c024391a3d8d254964a9" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    pyver = Language::Python.major_minor_version "python3"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dpython3-girdir=#{lib}/python#{pyver}/site-packages/gi/overrides", ".."
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
