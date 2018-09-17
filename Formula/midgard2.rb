class Midgard2 < Formula
  desc "Generic content repository for web and desktop applications"
  homepage "http://www.midgard-project.org/"
  url "https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz"
  sha256 "7c1d17e061df8f3b39fd8944ab97ab7220219b470f7874e74471702d2caca2cb"
  revision 1

  bottle do
    sha256 "2172742db4d9b9a311cce2d5d96a31ddaa3b924361b5e524ab1c841cf0a3f8fa" => :mojave
    sha256 "c441435a2ea2a9c9ec76b066e9d03ff2bf49d3bd6484f1a61308a77ef4f536bb" => :high_sierra
    sha256 "5c522e6151422dcc32f28f276f8315b66aab03c8147ea85f8f4b5f1700a664d2" => :sierra
    sha256 "e9c17c300e476ee15ca5d3ccc34c70715da56a8e7be41a7e0638d3dfbbf49113" => :el_capitan
    sha256 "b1d949df0056f3855adfdd4542825fbffa13043e4666516662b3e69f81c24e2b" => :yosemite
    sha256 "8cb700e06f34ca0a08745d42f53dc2b451eb7a739105dda3aade4db2b03a9a3f" => :mavericks
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
