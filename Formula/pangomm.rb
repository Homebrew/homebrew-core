class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.50/pangomm-2.50.1.tar.xz"
  sha256 "ccc9923413e408c2bff637df663248327d72822f11e394b423e1c5652b7d9214"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "59de56c6a4d3f2b8a15333356753d1963837460e83a03bcfd573989b52b5af31"
    sha256 cellar: :any, arm64_big_sur:  "c0a230a9aac8bbbb950d58676b14232ebc7a3361fd42b6bc55bbb4cfc505f48a"
    sha256 cellar: :any, monterey:       "38fd4cffb42aa0aeee7b836b245d932681616bdaa99940289977cb3a62d9beba"
    sha256 cellar: :any, big_sur:        "bdcec6b945cca9af6c9aaa8d7ae65ddd18f16b3acc5d053daaf6d5c111c8f20a"
    sha256 cellar: :any, catalina:       "383a8e00e5459b350d53228fd5623d52bd9aa618eeeb8410ab7255158a5d3a74"
    sha256               x86_64_linux:   "fa8fb430d4fc22f2f493e8ced97e2518f6403cbca50879eb14ec91f327217cda"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.16
      -I#{cairomm.opt_lib}/cairomm-1.16/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.68
      -I#{glibmm.opt_include}/glibmm-2.68
      -I#{glibmm.opt_lib}/giomm-2.68/include
      -I#{glibmm.opt_lib}/glibmm-2.68/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pangomm-2.48
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/pangomm-2.48/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lcairo
      -lcairomm-1.16
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-2.48
      -lsigc-3.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
