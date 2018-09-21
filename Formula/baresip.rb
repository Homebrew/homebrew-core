class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.10.tar.gz"
  sha256 "393fb010410d3fc6a4879cfda235f0ec98439be5d1dca02c15f3416f7110a7fb"

  bottle do
    sha256 "a7d010f0c6ea77cfe38e34a26d163fda8994c2e903988b70d8771e685eeb3c5e" => :mojave
    sha256 "2d21997680aa9d6faba15c4e786afddf9c76f2fc51887475de59d56262fcf785" => :high_sierra
    sha256 "b60def84ebf98e806916f400f602036824b03d3b8b1dd97d44929fe2004ad1ff" => :sierra
    sha256 "f23e3075e1d9b114d1b4022d831f9d4639d3a17438b2f79eb6919dc9819c3387" => :el_capitan
  end

  depends_on "libre"
  depends_on "librem"

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
