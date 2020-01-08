class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.3.3.tar.xz"
  sha256 "213e82bd716c9de6db2f98bcadbc4c24c7e2efe8c75939a1a84e28539c4e1748"

  bottle do
    cellar :any
    sha256 "c33809e09990a272cff9d0aae609eab10f605bae909b6d4c14e5af5096e3b0c9" => :catalina
    sha256 "ef7f0557e79c99a79814f4ed29120719eea153f12b774a207e19d9b61658660f" => :mojave
    sha256 "bd5a61be6c9f3b75f5012f56b2db4bf351d991675dd8f6ddb18c74e7c985d0fb" => :high_sierra
    sha256 "aa3dc4ddf9802576ea7f3ef73bf7276c54720de3378c7b4d0a708707644c2089" => :sierra
  end

  head do
    url "https://git.xiph.org/flac.git"

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
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed", "--output-name=out.raw", test_fixtures("test.flac")
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
