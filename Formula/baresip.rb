class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.8.2.tar.gz"
  sha256 "b2e3f1f0faf04b24a82007f6cbe7636f9dc760ce565cec69e2e07a706003db08"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "ee8fa9a2dd390a92cbdc81f97df0fa823d12b3caaaedda3f8850d5ccb2027bc0"
    sha256 arm64_big_sur:  "d4996c8430f3a4767258d832ed8e517e5ed0984aa5f848c7db0bd6bc784e41ef"
    sha256 monterey:       "9626cc86a244e39f1ad3e6c91f03dc4bf4033854fa6789b5d480535d472145f6"
    sha256 big_sur:        "c4103c53e9b124b6ba6426c319fe037a70671fa0760312214e80a3e8d6457dd2"
    sha256 catalina:       "7943b44095ae4e9663c8c36873fbe1d95583295771e48fb89114daa412f6d8f8"
    sha256 x86_64_linux:   "a834791deb686f9561e8d05fcfe1ed56dce16c4ba34c3da515a87937d6d18a37"
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
