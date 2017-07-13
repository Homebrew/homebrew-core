class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz"
  mirror "https://downloads.sourceforge.net/project/flac/flac-src/flac-1.3.2.tar.xz"
  sha256 "91cfc3ed61dc40f47f050a109b08610667d73477af6ef36dcad31c31a4a8d53f"

  bottle do
    cellar :any
    sha256 "332f6f0968ceb21ea233140d59d01c63bd7f40de2c2a612e4ae1719f8ecf7801" => :sierra
    sha256 "720aebe4647f462b7d5202d38b499b0bbe507236e16111ff81ebf549738d43d9" => :el_capitan
    sha256 "74a964ef7aa1d2f0d774c71ea894a0ab972d08280032042e4ab6b73836bdf824" => :yosemite
  end

  head do
    url "https://git.xiph.org/flac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional

  fails_with :clang do
    build 500
    cause "Undefined symbols ___cpuid and ___cpuid_count"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-static
    ]

    args << "--disable-asm-optimizations" if Hardware::CPU.is_32_bit?
    args << "--without-ogg" if build.without? "libogg"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    raw_data = "pseudo audio data that stays the same \x00\xff\xda"
    (testpath/"in.raw").write raw_data
    # encode and decode
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=in.flac", "in.raw"
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed", "--output-name=out.raw", "in.flac"
    # diff input and output
    system "diff", "in.raw", "out.raw"
  end
end
