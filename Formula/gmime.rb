class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.21.tar.xz"
  sha256 "e6f40bb3f11b71f8004e7a91d9e20b2abe3898d211d0d815c061121bbcddb54f"

  bottle do
    cellar :any
    sha256 "cb981e780b4171bd0547071cd3774fd853a1c59fbcaad68d2a5264e9be8a3917" => :sierra
    sha256 "848440f6eaec305993135ee8708b81ad5ae2cfa9cfb5f7e6fcc8f4d077e9eda0" => :el_capitan
    sha256 "445348c5634172858befc936961626d1bc45ee6e6119f11b764032efc1b96687" => :yosemite
    sha256 "be33acb8e9285f2d17a0895fb7c85b0938c517708e81ea3de34a86065f0c49cd" => :mavericks
    sha256 "89e935d9ed23f2c5c426e2f19a112a682e71e805ac89f7faf91f102e24676691" => :mountain_lion
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
