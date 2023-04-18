class GnomeAutoar < Formula
  desc "GNOME library for archive handling"
  homepage "https://github.com/GNOME/gnome-autoar"
  url "https://download.gnome.org/sources/gnome-autoar/0.4/gnome-autoar-0.4.4.tar.xz"
  sha256 "c0afbe333bcf3cb1441a1f574cc8ec7b1b8197779145d4edeee2896fdacfc3c2"
  license "LGPL-2.1-or-later"

  # gnome-autoar doesn't seem to follow the typical GNOME version format where
  # even-numbered minor versions are stable, so we override the default regex
  # from the `Gnome` strategy.
  livecheck do
    url :stable
    regex(/gnome-autoar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "53caf3329b3d4a54f5031a4456f86eb12eefd0d8dea36df3ce54afeb72e52c02"
    sha256 cellar: :any, arm64_monterey: "e10db77c19ff115e5995a8692c0920668f02779b766e3ff9017739570554fa82"
    sha256 cellar: :any, arm64_big_sur:  "bef367c910a48355826f1a68b6559c745ece649aaa5b286ec771143278ab48d1"
    sha256 cellar: :any, ventura:        "8a94a0c9e9b51afba14c7f66f674200b5cfb5422169b8e2cbba840cb96adc574"
    sha256 cellar: :any, monterey:       "028851ac6b3a2f4b9bdaadf06b8591867c6e0ea4fd07a3ebb8d06d1743647fde"
    sha256 cellar: :any, big_sur:        "2ff4820fa4dfc5b43d6ff81d7d20cae54240af35b05f6bbd2538b3e575e85a84"
    sha256               x86_64_linux:   "106a75d05056cb20a8776d7c72f872e22ee1986aa02c28b26934796aaec01aa7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
