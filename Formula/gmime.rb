class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.23.tar.xz"
  sha256 "7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a"

  bottle do
    sha256 "86225b6bfb8839d6641d3a7e158fb71ddcb84d9613acea8238b3e9e31cd33888" => :sierra
    sha256 "0cb3dbc9dede5046e04ae5024afed3934a52ffb208d1ebc21e5d36a71aed7385" => :el_capitan
    sha256 "bbc9ad0689d9c35835a8ca9ee1d162807ee107bb10bf447f23c4858f4d7f42ca" => :yosemite
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
