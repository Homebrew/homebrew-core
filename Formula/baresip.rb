class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "fe0aeb3ae1d9c2d3bcc6d1a53adb8dbd34740de287a40a2d59d6c0cec58943c7"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "0cafcad6c6a3b13c298c0fef3646888cfc7d8e4ec5535f04ea16e8339a57d45b"
    sha256 arm64_monterey: "0f8d6a6c4a3664cd275720fd810b5a210ccff1dc0c1f4d2687f59a51adc5f341"
    sha256 arm64_big_sur:  "63640cb9406809b1ea99c17f3eb84860ab121bee4823a121952071203f903a97"
    sha256 ventura:        "e7e179bbd15bee1b9da4c0f8de23e4f3864ca9222a6a5157e3a2755ee214a70f"
    sha256 monterey:       "ac118460d14f62a5b6fd93eb678e371355ef97924fac51dcb7ec550c7a75e27f"
    sha256 big_sur:        "77240b2aa79c92acffcffb51040a6c9567eda6e8c886eecf317a3f089bb61f95"
    sha256 x86_64_linux:   "a2c7f7c663930e887c60ebae525bae0cada7be7368b684d9d110ec5159b900dc"
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
