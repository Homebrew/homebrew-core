class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://wvware.sourceforge.io/libwmf.html"
  url "https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz"
  sha256 "5b345c69220545d003ad52bfd035d5d6f4f075e65204114a9e875e84895a7cf8"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/libwmf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "1f89c6e1b24e93fd7da667bef0e58476e8db973bbdff90803f45ce45a58df0fc"
    sha256 arm64_big_sur:  "641d8c9c953f8b1e5c5b122a38582ccfdeeb37f92d11dbe0f353bed473053c92"
    sha256 monterey:       "e149c022245668436bcab7911f8344468c270ee437012edad17ca3c4db42fd7d"
    sha256 big_sur:        "2c1e4e481c00fdc9a6590bb65d39df1b87bbd054a1ecf20369049127b198c3a9"
    sha256 catalina:       "4fa5b3dc0b38f72ac7c4d15f4e23bc96c0808d48de28005c4dc74d50292ddf62"
    sha256 mojave:         "3e0e8ecd7072819856393b472017d1e7fc3995a6d8568c6ad65b7d1055efc2e7"
    sha256 high_sierra:    "a96fe2e0aef8cd0f8eecce05b8789c2637f973a6ae358924c451b8f36b3a70ef"
    sha256 sierra:         "9df806eb6a4a3ca1a2b4b656ff02623175892981fbf136c89d4df5b5853bd20c"
    sha256 el_capitan:     "205bf519460576ecf73e9314ba1171542be58ea22cea81c26424d661734f2d2f"
    sha256 yosemite:       "3554c19cc80eb6435ad630587a38dd094a3f33008c11a93a622f1eb62b2a3e2e"
    sha256 x86_64_linux:   "601eaf0675dc226c04cb3b52179f8af294317b51307de9067d6506ae60e0dbbb"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}"
    system "make"
    ENV.deparallelize # yet another rubbish Makefile
    system "make", "install"
  end
end
