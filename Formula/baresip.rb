class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.8.2.tar.gz"
  sha256 "b2e3f1f0faf04b24a82007f6cbe7636f9dc760ce565cec69e2e07a706003db08"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_monterey: "6f6e04207e628d7bb34d408a581b7a0c5dbc7ae4434d433790780f35fa4823e5"
    sha256 arm64_big_sur:  "3b407d74d28c8e4c788ea79a713e7caa6318a4f35c1952d51aab9653e61033ba"
    sha256 monterey:       "6232bd9e2b7e9f78becfda0d496e80287240c84c38d45789b15c2a3cda3d693b"
    sha256 big_sur:        "82b57786699ce01ad2f5fe36d4d09f618f9fb6d4fa1f07e82ea04a8e59dd53a2"
    sha256 catalina:       "26b12331ef4f5063c043efd2c99a65a8be26c4b7f8ce5e0a0b936b8fa455328d"
    sha256 x86_64_linux:   "29ca7f57521e6943326a7f70ef2053246d01b124a11785cb8118d147f601f4a8"
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
