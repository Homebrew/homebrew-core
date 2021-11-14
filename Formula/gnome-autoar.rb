class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.4/gnome-autoar-0.4.1.tar.xz"
  sha256 "646bd50ebad92d91c1be89097a15364156157442cac1471ded7ecb27d9a9150e"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d3de2aa29e6d4985445e38f6b3cd472cc6bf3c64bd6e488a0945e71b69ff8e27"
    sha256 cellar: :any, arm64_big_sur:  "c878f58ddccf4f6ccb9fb21f85284434072706235dca4dcd281b02fe3206ca4c"
    sha256 cellar: :any, monterey:       "583a8ed2ae52701cc87632713e841c0d6be37f7ee24f5991359648826392406d"
    sha256 cellar: :any, big_sur:        "28531f6dadc4e792c3689da6c041a65134a5f9a3eeb8cefdddba3e91dbc2fddc"
    sha256 cellar: :any, catalina:       "0de2d5a412701bd644080e47c4dcae47f262f76a6f5762477f3497f42202d647"
    sha256 cellar: :any, mojave:         "93261513fc4078cecc0e921d809de1f549e5c39e83cf06fbbeaea194fe83b850"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gtk+3"
  depends_on "libarchive"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnome-autoar/gnome-autoar.h>

      int main(int argc, char *argv[]) {
        GType type = autoar_extractor_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libarchive = Formula["libarchive"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gnome-autoar-0
      -I#{libarchive.opt_include}
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{lib}
      -larchive
      -lgio-2.0
      -lglib-2.0
      -lgnome-autoar-0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
