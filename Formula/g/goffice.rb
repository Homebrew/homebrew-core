class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://gitlab.gnome.org/GNOME/goffice"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.57.tar.xz"
  sha256 "66bfd7e31d2f6756d5a62c3670383cbba02b3cb4c1042950192a801b72a3c9ab"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_sequoia:  "d4ca91bb298e7dc0444609b9a09ceb404b81743329d462f1eb62a2a2046d525d"
    sha256 arm64_sonoma:   "a946184d2ad6fc95b59fb4c68a598aefebd8df3633d49a9b53decebea9eee6c9"
    sha256 arm64_ventura:  "c50b18823cc2a8efc038b7487dc1f229425709be9398e29b558d5747b2454006"
    sha256 arm64_monterey: "d28569db16793e715714a51758ab7429f8be117d964d8035e7062550c03b3a4d"
    sha256 sonoma:         "32b61c93a65c288cad554a876550c1793e41a3465e792557bc6810c339b8bf8b"
    sha256 ventura:        "88b7b7f99dae20d363f196ec55427158efd1ea0b0da3f2985b14fc0e637e6a63"
    sha256 monterey:       "dea1e444318e1364a1a9c96ec0a2b76b74df27b0576d820a354dfc378d4ef519"
    sha256 x86_64_linux:   "6d3ceb9fbd03a344ad62974ed5cd4365242c42397d323b89c3421416191ecb20"
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

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
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
           "-I#{Formula["at-spi2-core"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
