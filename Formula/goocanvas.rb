class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://wiki.gnome.org/Projects/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/3.0/goocanvas-3.0.0.tar.xz"
  sha256 "670a7557fe185c2703a14a07506156eceb7cea3b4bf75076a573f34ac52b401a"

  bottle do
    sha256                               arm64_monterey: "82c8618cacc3ede0528d7b5642df008d85004ffcb2dca6161854191fc5f7305f"
    sha256                               arm64_big_sur:  "afc6329ef248fba21b033b7f9e409112260e28f0c9964e5748df4bed40a0cdae"
    sha256                               monterey:       "54771e536701697bd1e1225d41c2ac1cb74ab05fc5b7e0500699acb469e7b65d"
    sha256                               big_sur:        "31471c7264bf173c9f82ba40daec0555403f9007cc8046d7bee5b2406bfeedae"
    sha256                               catalina:       "ff71ce064b86b1e8973ee5c6aaebdbba6a1159614f5c425d83cc3fb6b00e8b97"
    sha256                               mojave:         "b9d36364339793b428077bbc7735981f8cd33e681971653806dc574236382778"
    sha256                               high_sierra:    "6822fe0a452809ce94bc1fd70fb32b024ad52702a56878db381b7dad2e05aa28"
    sha256                               sierra:         "44b1bd9f058cd4fe112cd1022a0ad2daa93c7f849257ae57bc6d10f9c33e57de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df27306b70d7a3b4ff8ab489bf4d3fe4cf9c2e9d6e49589095b1c6b2c5926ca0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-gtk-doc-html",
                          "--disable-silent-rules",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
