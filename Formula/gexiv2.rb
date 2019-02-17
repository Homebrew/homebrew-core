class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.10.tar.xz"
  sha256 "7d9ad7147ab51ab691edf043c44a0a44de4088c48a12d9c23c26939710e66ce1"
  revision 1

  bottle do
    sha256 "9d493db238b17a55c2715d6d76bf6ce5aff790e2c4367952ea752d507e04407d" => :mojave
    sha256 "76a1cb2441e51f9e5d05290bb29075706776f7bdc0174155adf2575fb75b76b7" => :high_sierra
    sha256 "132d5fac5817a9b1acddd6e9355ae2515168c9af9907293e673aee03c0aac63f" => :sierra
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
