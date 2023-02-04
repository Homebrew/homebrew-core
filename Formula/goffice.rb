class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.55.tar.xz"
  sha256 "16a221191855a6a6c0d06b1ef8e481cf3f52041a654ec96d35817045ba1a99af"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_ventura:  "c714b0618b08bfd4a2b8d1f093b9e5a9a8c1a3909bf79e97b3b373252c75dbdd"
    sha256 arm64_monterey: "46647af83047037b79fe86a9b7a4fb1dbbbd11fef94e2c871b3d96911cb2b649"
    sha256 arm64_big_sur:  "7236c998a8738d5e66bcd7d5e1c49d2ffc9f033f59f540c834fb3c5c9a2f5e24"
    sha256 ventura:        "420dd27eefb3e786dd528c038ecab66c77e7bffd6690d7014ca765cc215842f2"
    sha256 monterey:       "198e22e9fc6780c0cd9757ad127da0be7db27cb2315ca292bbf3f761b86362e8"
    sha256 big_sur:        "6f81e80829c1ccd7e69b9e49fd2c1b4bba97f71354e29aeb7b33cec8c54aeea5"
    sha256 x86_64_linux:   "ef24735ed6b8512d77c0147f7dc587f4a0d898611a447c86f3b35bb36a74e431"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/goffice.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args, "--disable-silent-rules"
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
