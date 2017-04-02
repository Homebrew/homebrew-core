class GtkMurrineEngine < Formula
  desc "Murrine GTK+ engine"
  homepage "https://github.com/GNOME/murrine"
  url "https://download.gnome.org/sources/murrine/0.98/murrine-0.98.2.tar.xz"
  sha256 "e9c68ae001b9130d0f9d1b311e8121a94e5c134b82553ba03971088e57d12c89"
  revision 1

  bottle do
    cellar :any
    sha256 "34cb6d93aa8c8b465a68c54579afac3b9260af5f251fd7f1e125930bab2edf9b" => :sierra
    sha256 "552525ea70d460775ffd1c73d34f6b7606b2ef6b34f58ef23b12d90659bbee8e" => :el_capitan
    sha256 "8f4b630aac7727177cb36f323348dfe1a77c6cff64367ba881b94e05403b0bda" => :yosemite
    sha256 "c04e691bfeca04d420f3f64990cd0b1d754bd87061757960bd6eda4e1b55c6c3" => :mavericks
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-animation"
    system "make", "install"
  end

  test do
    assert (lib/"gtk-2.0/2.10.0/engines/libmurrine.so").exist?
    assert (share/"gtk-engines/murrine.xml").exist?
  end
end
