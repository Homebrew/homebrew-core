class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.0.tar.gz"
  sha256 "4c364f4bb2cf17f83b6ff2b35962fd94258158202dfa566f68531e8ba77c1436"

  bottle do
    sha256 "3afae7bb354ef15e3b277e3a5621672e3cbf0fe3ba4ba5cd4af72dc3427c376f" => :sierra
    sha256 "570afad75e57d5b52918285036cf55e133e4354cf6267f29200cb9bb8ad28e94" => :el_capitan
    sha256 "589cc2e4213cf000403fda87ebd6945f60be7383f804e3cd5bb20127272929bd" => :yosemite
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
