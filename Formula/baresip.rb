class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.17.tar.gz"
  sha256 "de7e6ff0185290eb50f2956d81a0fcdcf2a2af76432f64f090dd7be5db53d680"

  bottle do
    revision 1
    sha256 "b507725a7a6041f160c80718200263f42aa5997561814bcd65e2038ee8c760c5" => :el_capitan
    sha256 "b6f28c477a0324400ddf907a4e071f619fdfa8432fd8858bbe7d146603cfd95c" => :yosemite
    sha256 "3081370e88e775a28e7eef63a805d7328dabe873590f848224cec34fc8876824" => :mavericks
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
