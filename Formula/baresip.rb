class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.6.0.tar.gz"
  sha256 "86e04cef08828515cc9e690cf0f37d8b0f1f69c6d84bd8eea7a70df05b0aca76"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "2c8311fc5c7c907ad5ac3060c12604b024330f1d4ca23fe79d7cd92fa58577cb"
    sha256 arm64_big_sur:  "aa749f85405e357fad2dded5f9ed98d5179ffcdff228f292589ac017a0ec8e3b"
    sha256 monterey:       "fa5eabb8e6557b486f26e7165897c138c9d2308852820884c42fd3767b42634a"
    sha256 big_sur:        "4670d8ced69670e7ad1f8d83b4b334a2a49cf4c83ff15800e66265fed3074b5f"
    sha256 catalina:       "4ade779b057e8cb9079a17b8d336349a87d1dd18928a3a87588a062ed1d8234e"
    sha256 x86_64_linux:   "c13d3d06ba27039442039b3109c40c087bc306f1fdfac2bf7a411360a746d90e"
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
