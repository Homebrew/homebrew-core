class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.53.tar.xz"
  sha256 "27fd58796faa1cd4cc0120c34ea85315a0891ec71f55bc6793c14ecf168a3f57"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_ventura:  "2fb61cc9cf1a09b28dd4cce9e605afd312c91650ae6ab8ba4bf70e869aa095eb"
    sha256 arm64_monterey: "2426ed9aaf3e27647f2c1d2f94f1bbec28508a523a7b3d3c85275b3c3c7be6e4"
    sha256 arm64_big_sur:  "1f4b90257ea35b0ab860a699a4157c58f516fd1eb4e5b96db57df1b97749b517"
    sha256 ventura:        "f175281be8b894ac62b17ccbce96fe1fa70f4ef33b191f33cdab07ef7655a66e"
    sha256 monterey:       "57727191aa501e1a7f354f02bdc3afdcd3dc416fc0341115852d15bd9170cec5"
    sha256 big_sur:        "4d58399efa826a093d22b526c5d3e8a6411dcd3eebec6dea69741b0338c251d0"
    sha256 catalina:       "e9d2ffd833d7d450c00deb779bac5dba5721db7b45350ca41b827bb232e50bbe"
    sha256 x86_64_linux:   "7aca0ab34ebbae29dbe4ea367f1e58feb4e00ca7e011152172265074b561afd6"
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
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

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
    libxml2 = if OS.mac?
      "#{MacOS.sdk_path}/usr/include/libxml2"
    else
      Formula["libxml2"].opt_include/"libxml2"
    end
    system ENV.cc, "-I#{include}/libgoffice-0.10",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["libgsf"].opt_include}/libgsf-1",
           "-I#{libxml2}",
           "-I#{Formula["gtk+3"].opt_include}/gtk-3.0",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdk-pixbuf"].opt_include}/gdk-pixbuf-2.0",
           "-I#{Formula["atk"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
