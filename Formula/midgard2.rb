class Midgard2 < Formula
  desc "Generic content repository for web and desktop applications"
  homepage "http://www.midgard-project.org/"
  url "https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz"
  sha256 "7c1d17e061df8f3b39fd8944ab97ab7220219b470f7874e74471702d2caca2cb"
  revision 1

  bottle do
    sha256 "b555f5eb0fcc97d313dad782c834663938cea52e64e00bfbf0555d1e74c9b303" => :el_capitan
    sha256 "92e816d0054901c0ac017e090609149b5252ea735c068d583a54e75e8471bf90" => :yosemite
    sha256 "ac9ebb309b40032df71e0bd73eef209acc7677e0ea4c30599db8b96559cb5870" => :mavericks
  end

  head do
    url "https://github.com/midgardproject/midgard-core.git", :branch => "ratatoskr"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "dbus-glib"
  depends_on "libgda"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libgda5
      --with-dbus-support
      --enable-introspection=no
    ]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
