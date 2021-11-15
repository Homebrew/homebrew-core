class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  stable do
    url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.50.tar.xz"
    sha256 "2c5c3ddc7b08b3452408c81b121c5f012a734981d75e444debccb1c58e5cbfdc"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_big_sur: "e571776d6027505872945c458da49905765f260bc76c197f83565ff1f9c06a6b"
    sha256 monterey:      "d15ea11e14aac441e2fc89b977e5799d6248ec3dd4a89b8098c3a4a30f1e37a9"
    sha256 big_sur:       "4cbc19a7ea37b8d511e2c908ab810c5655d76af9f13cffbaafdc39bac01ad009"
    sha256 catalina:      "b21162268cc6c6dc2bdb7c63f6ea7b95eb3db9228f75536b98bf7fabff4ea9e8"
    sha256 mojave:        "e7e8f0d817617e0b4450bc77905d988cd06918e45992881eeaba24c61b2e4030"
    sha256 x86_64_linux:  "624e24a561aa035fec52a249672fc38368754cb64c00f4b2b72e22bb53fa0f7b"
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
    libxml2 = "#{MacOS.sdk_path}/usr/include/libxml2"
    on_linux do
      libxml2 = Formula["libxml2"].opt_include/"libxml2"
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
