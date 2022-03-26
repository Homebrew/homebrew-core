class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.38/atk-2.38.0.tar.xz"
  sha256 "ac4de2a4ef4bd5665052952fe169657e65e895c5057dffb3c2a810f6191a0c36"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2bbb8f77fc0b5cccd3a01e0d1f18e4f7c26a085f8224430b2e5ea094357e91d6"
    sha256 cellar: :any, arm64_big_sur:  "e7d40dbacc2c965c8b23224a5e1cd2a90d6c54758b957dcf3d66c2238feec518"
    sha256 cellar: :any, monterey:       "52624a3ef69933bcac6b9fd22ce4c0aed8c7d038cc21fc4b7a5d7d5b059c4756"
    sha256 cellar: :any, big_sur:        "8321e0ee7364e1de1a3667c50954b4b4f629cba7c2d8077114c4a5bc38a24655"
    sha256 cellar: :any, catalina:       "1065293046ab2984940dfa0b9c9e724439838e63f685c932d508ccd74bcf921b"
    sha256 cellar: :any, mojave:         "68c7b621339c03964036877987db69806f663612ba275e68554a97d218a2b5b4"
    sha256 cellar: :any, high_sierra:    "fa8f525bfeacab676f795bac37f622fc100e63c9e9661fbd6ddd3e1725ebd097"
    sha256               x86_64_linux:   "22fce3b8041576c4ab184bef170f8902c73ad9b79809b2aa0ef79049f5c5ac43"
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
