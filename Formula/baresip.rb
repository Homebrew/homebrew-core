class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.7.0.tar.gz"
  sha256 "6bc3ac1b2a301b6de91a40079a9ec44545a00c57662ca0bdf2518fbb932ff181"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "c3a6a4209ac3ea8d95476017d3798487d0a31b215adbfcbe500251fd716fd97d"
    sha256 arm64_big_sur:  "46e2156056096a916a8b50feef733e077aba639f17eed5f226fcbf8bc996cdec"
    sha256 monterey:       "f665fee266d3b300cb6774db937020a6e439790a6a8802d12aacd4b3dec8cb3d"
    sha256 big_sur:        "26758f25ba5163e00fea8fd91e7eea2175df4f76d6648e36f9d99eae9e100cfb"
    sha256 catalina:       "c2577ff068c8ffd4f11b32e745be8e93b2c6e7c8f369789560523ef546603cae"
    sha256 x86_64_linux:   "2e03c3923b100c126c9a9a414be581482e272de13de83fcff8f6138ecda5dac4"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    # NOTE: `LIBRE_SO` is a directory but `LIBREM_SO` is a shared library.
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib/shared_library("librem")}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      V=1
    ]
    if OS.mac?
      args << "USE_AVCAPTURE=1"
      args << "USE_COREAUDIO=1"
    end
    system "make", "install", *args
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
