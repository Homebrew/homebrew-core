class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.9.tar.xz"
  sha256 "8806234aa6fd1c345d46bf07a14e82771415071ca5ff63615b1ea62bd2fec0ed"

  bottle do
    sha256 "4af36560dece00e6cb5d68ca743f52a9de78121fa184ef1a4add25de6b97f598" => :mojave
    sha256 "e8acce6d1a7fdcf5b14b5e64e641c04d0ca32f5198af59bbe08b2cc91513f5c2" => :high_sierra
    sha256 "4b74b438069c0968d08d7b75aaf1333454cd6005577f2241ac5f78460f4a847f" => :sierra
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
