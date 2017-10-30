class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.6.tar.xz"
  sha256 "132788919667254b42c026ab39ab3c3a5be59be8575c05fa4b371ca8aed55825"
  revision 1

  bottle do
    sha256 "6433421bf86059843a83cd6c56a4acd9b87477ea7429b929e7cbf1dd6936aa64" => :high_sierra
    sha256 "c862648b1cf611de870f778d0b8b30e79d919a751fdc9993a0ee6726ec1ad484" => :sierra
    sha256 "60442fde03140dfb12725a4a3e0b8bf0ea982aa19ff14754774df75f0b375ab8" => :el_capitan
    sha256 "b139bc8038931b0ed5f3026f48d3c421ba99ee6041333b025a2aedc6639d96dc" => :yosemite
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
