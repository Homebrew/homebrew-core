class Midgard2 < Formula
  desc "Generic content repository for web and desktop applications"
  homepage "http://www.midgard-project.org/"
  license "LGPL-2.0"
  revision 2

  stable do
    url "https://github.com/downloads/midgardproject/midgard-core/midgard2-core-12.09.tar.gz"
    sha256 "7c1d17e061df8f3b39fd8944ab97ab7220219b470f7874e74471702d2caca2cb"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  bottle do
    sha256 arm64_monterey: "a895e75f191eae0c7483f72ab017b382408d5c2e695b45501899bb851afd404f"
    sha256 arm64_big_sur:  "60df7b2c0c5128949c9ad6c8cea8bce50b2abbbf1405da2e2a7681745eea90d0"
    sha256 monterey:       "0298dfd2a09496215031d1c3f86e316922b1308bb9310d109ec5e4313127e5c3"
    sha256 big_sur:        "e0e95184827d7b69fa0c39d3bca827d600e38db97541606f48edd14c08d3a2a3"
    sha256 catalina:       "c3ed243fb5c433a40f959a357c8c78258a62b2fcc7eb5f3e6d94ca0b9cae3159"
    sha256 mojave:         "d37c0fefe73ad6e8360585d80e26e11f7e1f5735fdf8382f0c3795f95fa93d68"
    sha256 high_sierra:    "08df9e1d7487d38c8174047aa9d0620bc1f430f23602acba90c2ec9978a3fdd9"
    sha256 sierra:         "2aec9cbfb7a432a4ad73157831b9d5f6573ae4b85141410040cb0f053435541a"
    sha256 x86_64_linux:   "832a02ad03489936522c500504ab060207992e9a25c0790828431d8c56d3020e"
  end

  head do
    url "https://github.com/midgardproject/midgard-core.git", branch: "ratatoskr"

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
