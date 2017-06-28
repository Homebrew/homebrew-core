class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.4.tar.gz"
  sha256 "710c16d209f8e5b7fd63433d27dd0ce2e651967a720ce5447162c268ec0e1c8a"

  bottle do
    sha256 "d97728c4347d3bd5a75cdbd1b2b43aabcfd18c26dd9a0552b87d76b0f745c002" => :sierra
    sha256 "19d6ba3cf7beb0163444c4634904751b43865af7a3a307e21b51227800217aa3" => :el_capitan
    sha256 "5c13318f2683da5ded44c6d89094a1d94a9b17ab0944dc37cb4955749b641d35" => :yosemite
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
