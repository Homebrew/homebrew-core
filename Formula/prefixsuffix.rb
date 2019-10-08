class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  revision 4

  bottle do
    sha256 "48603e67c0d43035c166ba203fd9f615ba35280f06f8827b98597da67f4d2c62" => :catalina
    sha256 "9a9b7ba884860fa4a3534e05118d08e0501e5b195b84a9baa476b49516d2b0a2" => :mojave
    sha256 "41422acfc4dfd9a6948623ad544174e70648d2644d763b22f3219bd832f28a7d" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtkmm3"

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
