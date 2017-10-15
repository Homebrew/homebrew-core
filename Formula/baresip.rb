class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.6.tar.gz"
  sha256 "148defef160842e0247af92c84bb0c8de4b36ffa68cf3a87c4cd7e510cddd00c"

  bottle do
    sha256 "46111db172ae0cdf09df0435598e1dc7a7df87b84e0332263b84763d336b20e4" => :high_sierra
    sha256 "d948fa5aedfa5f8b06be98b3e84d4106ef40c3ee0d11b34d5baddfd6e47fd40c" => :sierra
    sha256 "43e599513d998e3b98feb072d5f0288f901ad3d43f704410845b10b7e27ca48a" => :el_capitan
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
