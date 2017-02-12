class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.23.tar.xz"
  sha256 "7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a"

  bottle do
    sha256 "05af2f1ac617529df02b43e6494c480cb442387a96702614ce3eba537d26989a" => :sierra
    sha256 "5b97393ade91622508cd7902a50b2bbeab57d109da9211b6d80053186a84d86a" => :el_capitan
    sha256 "a74503cf97b51a46a7b43f862c1b9cd1f2220b3fc38ba4b56f607b72371f28aa" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--enable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make", "install"
  end
end
