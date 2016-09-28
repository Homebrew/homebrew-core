class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.19.tar.gz"
  sha256 "bb8c62da225d7ee30ad371e6e0cd0f4bb663635e73b8c09cd43b054b981eb0d1"

  bottle do
    sha256 "b9b158d2b02da29d39c836282cf616bc11c848c7aa9b99c6512cebfddc49f7b6" => :sierra
    sha256 "7579614477b3ec6ce353772ce8115e0290315ae434f60b6f2a844a5b0a201fda" => :el_capitan
    sha256 "272859cf96c1a8e025e1000e804cc18e2cf91237b45e6e0d8d962724cb3aa479" => :yosemite
    sha256 "c33fbc939c0582e0ee2e5877a5ecf6524d0d2c25cf82a15081e04f688ed19dfc" => :mavericks
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
