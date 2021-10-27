class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.3.3.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.3.3.tar.xz"
  sha256 "213e82bd716c9de6db2f98bcadbc4c24c7e2efe8c75939a1a84e28539c4e1748"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/flac/?C=M&O=D"
    regex(/href=.*?flac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "17dfe556bd6dfccc5cefc783cabe5ff63cc1165af81f804c185c234de8311380"
    sha256 cellar: :any,                 arm64_big_sur:  "0df3b501847bb370e70f11cd2758271048ad7caf9dd994e220bd2974fa162939"
    sha256 cellar: :any,                 monterey:       "63f8a96c50be242ddc40003f25ebce247a769bab4d975e6f754b857fda6be69c"
    sha256 cellar: :any,                 big_sur:        "2fd6b2eac2d88c39022752992baf18f4fa0deb43c1b27c57dc9d2349562c9514"
    sha256 cellar: :any,                 catalina:       "3d33119f1e513ad58f20722e41498fc23315d756a834d8b346cee6842f45fea1"
    sha256 cellar: :any,                 mojave:         "ffadc5a1825acd43aee92ea2523a1b46b3c63820f5cf59f61ee2972571454755"
    sha256 cellar: :any,                 high_sierra:    "53562e93cd58b45d15fb5303938b1718298d69101a53612fd53075e881cbfc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5259b441b01df1835122e3cbe62cc8aaddc0de6254e8e570f395f0d09c5f008"
  end

  head do
    url "https://gitlab.xiph.org/xiph/flac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-static
    ]
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed",
                          "--output-name=out.raw", test_fixtures("test.flac")
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8",
                          "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
