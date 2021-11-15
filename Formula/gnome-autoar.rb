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
    sha256 cellar: :any, arm64_monterey: "6083f2fef0c5265a0146e05ab241fb4dce7f09442ca0a53898712fa9b022af83"
    sha256 cellar: :any, arm64_big_sur:  "92a5874a1c8f8c6a27465c8ca186b7813898ce65154c73e6c62f00192619a3eb"
    sha256 cellar: :any, monterey:       "f52638834f3691698469188275254f8cdb647e1bbe040c7421f716d85e0801c7"
    sha256 cellar: :any, big_sur:        "b59d4adb70998430549c885e7557eb3e6d46efba9e33120dcac861fa1fa4f2e5"
    sha256 cellar: :any, catalina:       "ec90973e8d6910e5d0296f4a40cf6c4e759ce678ddc9e2aa59669ee6c60c7603"
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
