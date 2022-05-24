class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  stable do
    url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.52.tar.xz"
    sha256 "60b9efd94370f0969b394f0aac8c6eb91e15ebc0ce1236b44aa735eb1c98840c"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 arm64_monterey: "822a9b41a614f5c29c665d3f89baf9a0fd35f202f882bc8ba310bca314ba5040"
    sha256 arm64_big_sur:  "f19ff9d2176f8559fa2c2adcd962cd1d4825922584cdc542ecaec3b0f4f6dabb"
    sha256 monterey:       "45a0a3a6b8d1dcf201123cd7e2ca3d4d9b73f041cfc8b37613e70d789b255e7d"
    sha256 big_sur:        "ad365fedda8bde06db2383ea8ec8e7b2eb8a73f144119c039d757f7ae17a8729"
    sha256 catalina:       "1a2355d6299eb4a1e23927e24f2fedc891b105a6d3401b49a43c48ffc035122d"
    sha256 x86_64_linux:   "92f81d59a2b32d40cfd3c850a23ccd930c28989520672f326bd25a9478acc66f"
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
