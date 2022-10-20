class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.8.2.tar.gz"
  sha256 "b2e3f1f0faf04b24a82007f6cbe7636f9dc760ce565cec69e2e07a706003db08"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_monterey: "045374d1a6ae260b92338bdabb7617cae083753f2c7a4a8be5afc2f2bff10c12"
    sha256 arm64_big_sur:  "19c5c355692feb77159452a0b0f99ea20eb8cc36797d9a4c0b78e5e20a5a6af4"
    sha256 monterey:       "a31f0a98e91053bba22a893e80ef4268a481bf2efe6256d17e063723dfa7b447"
    sha256 big_sur:        "77da6e4b2e97b8e98d8056a071f1156a7bd98db35ca56d0df5a071407aa796a4"
    sha256 catalina:       "70d4e347490cd3731b88bc7245dc017cb96676d64f8f6370edf6229fb9b3fe7d"
    sha256 x86_64_linux:   "adc707e1b3e4786a3827de7f7b4dfc2cc7191ba00402d66e2751e5a70a177e66"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      RELEASE=1
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
