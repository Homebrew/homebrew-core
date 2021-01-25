class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz"
  sha256 "fb76247e369402be23f1f5c65d38a9639c1164d934e40f6a9cf3c9e96b652788"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8321e0ee7364e1de1a3667c50954b4b4f629cba7c2d8077114c4a5bc38a24655" => :big_sur
    sha256 "e7d40dbacc2c965c8b23224a5e1cd2a90d6c54758b957dcf3d66c2238feec518" => :arm64_big_sur
    sha256 "1065293046ab2984940dfa0b9c9e724439838e63f685c932d508ccd74bcf921b" => :catalina
    sha256 "68c7b621339c03964036877987db69806f663612ba275e68554a97d218a2b5b4" => :mojave
    sha256 "fa8f525bfeacab676f795bac37f622fc100e63c9e9661fbd6ddd3e1725ebd097" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
