class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.44.tar.xz"
  sha256 "6d6042af92cd962604068dbced5925948af6c812c2138defc3153c204d65a7b9"

  bottle do
    sha256 "a9eafcb914155410521e28a0b88c569473decccd48d9d62cf3a6e2576816584f" => :mojave
    sha256 "355f1965f78ee4804401b6d0dc23f023f1148d904dd24e5b594ccb28a4805019" => :high_sierra
    sha256 "25a629717d68b0daab34a416e51eac29fc233d32356bde257e8881994dc730e0" => :sierra
  end

  head do
    url "https://github.com/GNOME/goffice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pcre"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <goffice/goffice.h>
      int main()
      {
          void
          libgoffice_init (void);
          void
          libgoffice_shutdown (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgoffice-0.10",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["libgsf"].opt_include}/libgsf-1",
           "-I#{MacOS.sdk_path}/usr/include/libxml2",
           "-I#{Formula["gtk+3"].opt_include}/gtk-3.0",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdk-pixbuf"].opt_include}/gdk-pixbuf-2.0",
           "-I#{Formula["atk"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
