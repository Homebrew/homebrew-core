class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.0.1.tar.gz"
  sha256 "8e7a5d228d2003aec8b4e570a32de5937e9bcbceff14803198fba767c514d362"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "a1623929ecb9f411bd1ab4fa607aaa74ec48db088ca9075ce5150319af22faad"
    sha256 arm64_big_sur:  "77f4fe8630f9f20ee699f35c7b382aeed1f9d0aca15d022c8c44953ad1139559"
    sha256 monterey:       "44b6ef568ced4088484499a8f627a283af2bc6ce32aaa1e0e9e4a43c4f0c69fe"
    sha256 big_sur:        "01fb027d2ef4ebb5ded6487930879b83f30140439b705813fefc5b8799b3ab5d"
    sha256 catalina:       "968f11a8d0fd310d3c3998e51c1d20588faa49354d9d5bb4193bc7ac91c0ea98"
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
