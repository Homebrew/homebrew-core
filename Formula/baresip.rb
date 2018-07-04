class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.10.tar.gz"
  sha256 "393fb010410d3fc6a4879cfda235f0ec98439be5d1dca02c15f3416f7110a7fb"

  bottle do
    sha256 "1199a3af90dc793d551f1c7dff6445a542bf410a50359ac1d5f076dd8eec982e" => :high_sierra
    sha256 "e395e1ca8040a2ae9e7365f068db10d9e121ba7fe2489f4a0a63d2f9a0f0a285" => :sierra
    sha256 "1e407eba531cc245529fd9f493f7bbca8d41e4281a98ee8afbf25fdc85522c6c" => :el_capitan
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
