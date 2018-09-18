class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  revision 1

  bottle do
    sha256 "87b5aed4fa1e4dd94b2d5f296d47078cd3f177e0c68bc7b16e285f2b8c40b83c" => :mojave
    sha256 "0a0937d3ebef51cf2c39007ea99e31f75490c07f7b6b441f64f7a87bbda54a7c" => :high_sierra
    sha256 "68a7a15fe3b8ea30c1f09e90dfbf8d95348367f74e497b9c1b31ac1795e71211" => :sierra
    sha256 "48cc4b33c63c410b4d5827f689ccf6ea59608deee4735f84edea90c2ddc394f1" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/prefixsuffix", "--version"
  end
end
