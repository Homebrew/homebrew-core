class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.1/libdvdnav-6.1.1.tar.bz2"
    sha256 "c191a7475947d323ff7680cf92c0fb1be8237701885f37656c64d04e98d18d48"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdnav/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77a874039ce80696ea655e95514dc26776a34f1c9675f583ebc0b9ae083be84c"
    sha256 cellar: :any,                 arm64_monterey: "efafd019d3a0cff8710e286c2fd7817865b1be5ff539c39639c71de9f61d9c50"
    sha256 cellar: :any,                 arm64_big_sur:  "e3ea0ddda7b96b799c2a67fd6687c25679001e2dc3893f200c70d4a599bc3996"
    sha256 cellar: :any,                 ventura:        "53d1dde0566dc12fe4e804d379d7b7cdfdc411dae8b290e866517c6f1023b796"
    sha256 cellar: :any,                 monterey:       "56d2c8450b882b776d5935a138d8031585366f59a740ea26db871d06c94d7d95"
    sha256 cellar: :any,                 big_sur:        "cabd25ecc0df8a3729e7196737e56041d8d6b9f369972d66de1ade19b4bfbafb"
    sha256 cellar: :any,                 catalina:       "ded7214f830c32676e5a64c2836b5498e44aeaa4967c5753a89c48af66edeaf7"
    sha256 cellar: :any,                 mojave:         "4fe58e754e7174ef7013a89a0620e05b8131bd50ed1de2c54e8b837db81fc4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0aadfc77f6807e5067f04391b0da4b6a0173c0219552f90ee300e17bd5679d9"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
