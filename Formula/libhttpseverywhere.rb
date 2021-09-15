class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.8/libhttpseverywhere-0.8.3.tar.xz"
  sha256 "1c006f5633842a2b131c1cf644ab929556fc27968a60da55c00955bd4934b6ca"
  license "LGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_big_sur: "006bf3748d65067509e5b2e6d506f3b0a9a52c5eaab54780850b70b7f82ff249"
    sha256 cellar: :any, big_sur:       "459d83997d7d69966ddee1e7a94e8583b4de8570ee1a796273a64a3d7845b8cd"
    sha256 cellar: :any, catalina:      "c8cc1d294949af9676e54f9a32c4dbe782dfc5d103f92bbee68acd2ccb5ff728"
    sha256 cellar: :any, mojave:        "2835c48e21e0a96730893f96319736e55d29d8b224fcc0915e319bcbc3b521c2"
    sha256 cellar: :any, high_sierra:   "9c7c9397a0ebe56b82ffa6d8daeb9e645e94d14ed4fd25aedbe313c603e0b9b5"
    sha256               x86_64_linux:  "e3e753458877d02da2c1d83c10f70ba493198f799026225ea2d250214311af55"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libgee"
  depends_on "libsoup"

  # see https://gitlab.gnome.org/GNOME/libhttpseverywhere/issues/1
  # remove when next version is released
  patch do
    url "https://gitlab.gnome.org/GNOME/libhttpseverywhere/commit/6da08ef1ade9ea267cecf14dd5cb2c3e6e5e50cb.diff"
    sha256 "e5499c290c5b48b243f67763a2c710acc5bd52b90541eb8da3f8b24b516f7430"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <httpseverywhere.h>

      int main(int argc, char *argv[]) {
        GType type = https_everywhere_context_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libarchive = Formula["libarchive"]
    libgee = Formula["libgee"]
    libsoup = Formula["libsoup"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/httpseverywhere-0.8
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libarchive.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -larchive
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lhttpseverywhere-0.8
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
