class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.4.tar.gz"
  sha256 "710c16d209f8e5b7fd63433d27dd0ce2e651967a720ce5447162c268ec0e1c8a"

  bottle do
    sha256 "a0e97dfd5efbb100ff712cf7ec5eec77f867b5a34099407ecb1aa8e558048835" => :sierra
    sha256 "d9b26cebd156ba6fd43eba873ad57135d06d22f5e7ca409745fab562c8be5df5" => :el_capitan
    sha256 "9952b751f556030faaad8c0a1260e2b9adcaaa039ec60ed3dd241edc99e8545e" => :yosemite
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
