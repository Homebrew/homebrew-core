class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.8.tar.xz"
  sha256 "e2876d987c00783ac3c1358e9da52794ac26f557e262194fcba60ac88bafa445"

  bottle do
    sha256 "6dc574ad6963f7779266af499e740d663fd70d26dd3e3212c57cdc556abc7060" => :mojave
    sha256 "ba273939064c8f4e4adc764660888e80b9be67486554dd25e00f5d941a0c0c0f" => :high_sierra
    sha256 "2183cd2116b161091c1a421a3e584064a754ab11f7838dbba9e5ece6b13fc3af" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libgee"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection"
    system "make"
    system "make", "install"
  end
end
