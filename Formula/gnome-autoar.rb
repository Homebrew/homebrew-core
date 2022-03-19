class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.4/gnome-autoar-0.4.3.tar.xz"
  sha256 "7bdf0789553496abddc3c963b0ce7363805c0c02c025feddebcaacc787249e88"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0df6603337a1cff502ba253b8801db07224f32598eb347f94fb5785378520fbc"
    sha256 cellar: :any, arm64_big_sur:  "cb7cbf77725dfb8c63132595f9328165d05c88ff06bb354c0439b619046ea089"
    sha256 cellar: :any, monterey:       "eb9b26d88d0999f3eda261336868815893a94680dfb59041093ca108a38a278c"
    sha256 cellar: :any, big_sur:        "a6b34eb24dbdc52a7e616dc1fda7bd10b37428d97a182006da2f6b18b34bbdfb"
    sha256 cellar: :any, catalina:       "ac757f0f9b548f9a993d6f4f80bcb2b48abbed49189b7c7ebad0b13e9a75ec0d"
    sha256               x86_64_linux:   "f19b2f3e7c3014bd7e65e2326b2d550ce10add78fc35c09bd6016cce51b98f6d"
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
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
