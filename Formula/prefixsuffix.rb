class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0"
  revision 5

  bottle do
    sha256 "24dc25fc90c2e0187c5ac94ea89856516c3a10573821c0f72f4154ce5694285a" => :catalina
    sha256 "cae14def9ca8939d6fc3dcf5c249c7a8e6af3d1bfd9f790157b52dae7b09e901" => :mojave
    sha256 "e216a904a8f6e6d2345767d04aac870ecd6efdd95aecb1b031644c3c90d56ec0" => :high_sierra
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
