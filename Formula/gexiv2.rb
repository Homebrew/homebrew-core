class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.5.tar.xz"
  sha256 "318fe068cd414c0af91759a87c29fd577cd5d42bf7a6f50caff27535c02ac7f3"

  bottle do
    sha256 "9bcb50feeaedd2aa01a3c9dca279301f8e366c370d15f03fbc1dae014a77fc5c" => :sierra
    sha256 "52056f0cc9405210101df91d2611652448f2c0e330c448a6e56bd0379a2065cc" => :el_capitan
    sha256 "63ed0d6a7ccaf0bab215a21ccd54eee9e7ad36cd7e8c31b75c382def37bd53c0" => :yosemite
    sha256 "04ba9507fd3e8c0aa84bcedad02db05387f12d965170d6dc594ab6a3d205106c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :build
  depends_on "python" if MacOS.version <= :mavericks
  depends_on "glib"
  depends_on "exiv2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection",
                          "--prefix=#{prefix}"


    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
