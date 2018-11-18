class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.9.tar.xz"
  sha256 "8806234aa6fd1c345d46bf07a14e82771415071ca5ff63615b1ea62bd2fec0ed"

  bottle do
    sha256 "a44a0225ab933dd6da6dadece5ed05a7dbb83b0372795a92f0bf6466c32e4535" => :mojave
    sha256 "c6da6deffd67e16ee41a570d6b2393caa04764c077b972c8b1ab6b5bde040261" => :high_sierra
    sha256 "ef19b3b862ba328ca17665f974355737389626e72075078a55a8bb00032bb9c9" => :sierra
    sha256 "be2ec9b0a9a314e982626156bb1b262648332334e57a03bc6c45b4ef14e223a1" => :el_capitan
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
