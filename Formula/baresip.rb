class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.5.1.tar.gz"
  sha256 "5ff4a3d85ce8fcdbac5391404d682ba843cbbc65b8827c6cd11727bcc209217a"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "7b527cc3708523dd1bce5e973ef80d9e51256a146664a3b4af5cb3a244af4b07"
    sha256 arm64_big_sur:  "eb2f9e40c956e9b09f50cdd24340e13cf5fb5a4dd19f7fa9eacc42022f7d7748"
    sha256 monterey:       "20fe25af455056a9aff96a529434e9fba7398342fc9e53cd341ee3f5122af5e7"
    sha256 big_sur:        "3473ce0689347e067788649cb3dec8198e4962af30d9ab8fe36a2db8af2c67b0"
    sha256 catalina:       "bb886674427f530fd35ab9d748e5203bbecbc1b80defe3c4c5ef5d2c8e83c1aa"
    sha256 x86_64_linux:   "9e17097a19718c532c293f815edaac4726c4bd289d6147cb51f36a83e7ebdc2a"
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
