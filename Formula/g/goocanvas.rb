class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://wiki.gnome.org/Projects/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/3.0/goocanvas-3.0.0.tar.xz"
  sha256 "670a7557fe185c2703a14a07506156eceb7cea3b4bf75076a573f34ac52b401a"

  bottle do
    sha256                               arm64_ventura:  "0d114696187598ad5a64abe30c3bdb162b81499901baf74d33bfe60e78a5dfdd"
    sha256                               arm64_monterey: "ffbe53df96aebdefad5bca437f0be3a0ca39b725736e943d300747a6bd7770dd"
    sha256                               arm64_big_sur:  "d2881f093f710abde959761a53e797e7b7adab47b359136c52974cd0d39d9b3f"
    sha256                               ventura:        "36413b12e3f7cf364cc16388e0dfd8f4592101516e8a26c3e506bc720fb0c582"
    sha256                               monterey:       "201056ff9afb6af37984ba0586e8fa0fd6d55a4f09d344754bf7394defd54570"
    sha256                               big_sur:        "2696cb6c47f70283a599e7b31d6ae359d1defb54d8c5cc2a466a0610ef8f470d"
    sha256                               catalina:       "28e1912c12842419642d61a4aa400dc7028a4dde604dcf06f8088bf7cf3cc3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f2a67e29fabc01031801decaff6a51fb6cd8196d33e78dca351b1aebe5f6a8f"
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
