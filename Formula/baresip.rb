class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.8.tar.gz"
  sha256 "d9f11da50fd6c9359ab478618b5d3c132474a838fe9f668c249f9d5a07f26662"

  bottle do
    sha256 "3df0b289483f598a0f21f3eb956f1d456acf9c0f877b9bcafc9cf59d0de67da1" => :high_sierra
    sha256 "0793cc24e65bf0a8a733365a9ff35e4b6f6b31d0139f89f5d4e9a84f55f61e3a" => :sierra
    sha256 "5ba8b1b235d6506c8774b94373257b767f9d7a4aed74f98aa54267baaec47dcb" => :el_capitan
  end

  depends_on "librem"
  depends_on "libre"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.installed? && MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1",
                              "USE_UUID=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t"
  end
end
