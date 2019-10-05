class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.45.tar.xz"
  sha256 "702ba567e9ec0bbdd9b1a8161cd24648b4868d57a6cb89128f13c125f6f31947"
  revision 2

  bottle do
    rebuild 1
    sha256 "ef4fe6945eb74bf39513711481785decbab630b8760bae2e40a0534636bfaf5d" => :mojave
    sha256 "a1796ae0a11115cce4756e7739d466189bf4a94d8b31a51a8d9fbbb5cbe988d8" => :high_sierra
    sha256 "a341815ae858d429a418c0a567b0dc204827cd196b5064326d83af40d6d5cb65" => :sierra
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
