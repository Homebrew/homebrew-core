class Midgard2 < Formula
  desc "Generic content repository for web and desktop applications"
  homepage "http://www.midgard-project.org/"
  url "https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz"
  sha256 "7c1d17e061df8f3b39fd8944ab97ab7220219b470f7874e74471702d2caca2cb"
  revision 2

  bottle do
    sha256 "c3ed243fb5c433a40f959a357c8c78258a62b2fcc7eb5f3e6d94ca0b9cae3159" => :catalina
    sha256 "d37c0fefe73ad6e8360585d80e26e11f7e1f5735fdf8382f0c3795f95fa93d68" => :mojave
    sha256 "08df9e1d7487d38c8174047aa9d0620bc1f430f23602acba90c2ec9978a3fdd9" => :high_sierra
    sha256 "2aec9cbfb7a432a4ad73157831b9d5f6573ae4b85141410040cb0f053435541a" => :sierra
  end

  head do
    url "https://github.com/midgardproject/midgard-core.git", :branch => "ratatoskr"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "dbus-glib"
  depends_on "glib"
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
