class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.7.tar.gz"
  sha256 "e66c16c7cf13bb3f43113f04e4d19edea3e49fb010d067238d5dc4a1aa1b8b7d"

  bottle do
    sha256 "52957fde6a1de8bb879bd6774284ba592f41a30d06b7abb3ba88c47ee8781009" => :high_sierra
    sha256 "36ebce2b54bb048498c6fa0a5e180a54567e452405279ca1d36134787d0bd819" => :sierra
    sha256 "71bdeef11d01598f0cb1e6e16846621b58161468bee5f53636e5167ab23fbf8f" => :el_capitan
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
