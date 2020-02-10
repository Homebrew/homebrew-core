class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.46.tar.xz"
  sha256 "058d6d3a40e1f60525682ec6b857c441d5deb50d0d30a76804f9f36f865a13a9"

  bottle do
    sha256 "0fe21687f0305ad07a1accb75eb6235490aae734c2b11262e20b62c7ee4968c3" => :catalina
    sha256 "5cdf0c352915329f46093c916ec4c5c2adecf6a7c46f695e70a9cb7e4f2fedae" => :mojave
    sha256 "faf193d186c3a95533149ee9df8a360e83c277687dbf7a43150b7fe299ee190e" => :high_sierra
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

  uses_from_macos "libxslt"

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
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
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
