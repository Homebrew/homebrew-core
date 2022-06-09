class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.4.0.tar.gz"
  sha256 "5939cdd5f37f164f2c3ccfdf4ae8f44d5aa40ed73c3517bdd88b080d575784b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "379b7e4f13e88b53ee6fc2248633682bdf9ea8a721e6eb9f1bb3c97d713bc532"
    sha256 arm64_big_sur:  "504991d4f884c50c4cba11c2b534adcebab9583a491910e79add42149ca55c13"
    sha256 monterey:       "29a0bee2928b881241e14356692ebaab1bfecd3c77b47ba3a89a4d2fb5f0d979"
    sha256 big_sur:        "41e4fdfdb1953a5b77a4909a0610e82ceecd8ce63c5123e4c10b4e4a4c96cb9e"
    sha256 catalina:       "5c114335ae47891878c67bcab4b63b61be07f1074020a459fa89a9348ce13c6c"
    sha256 x86_64_linux:   "9566b4a2c9de748983b20f152cae6e3a7aceae46c53d90c7a9fad419f7ca1ff8"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

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
