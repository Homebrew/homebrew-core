class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.5.7.tar.gz"
  sha256 "e66c16c7cf13bb3f43113f04e4d19edea3e49fb010d067238d5dc4a1aa1b8b7d"

  bottle do
    sha256 "6c8df83b6b8be52a9abd1124fe448eb98a799de376b13836223947b3d0a49be0" => :high_sierra
    sha256 "245523e5efe7d9937690f514bd0c9595ea5daf4e9534f1f3fc6bb3429be580b6" => :sierra
    sha256 "b57c146a805fd2ea21355aeff0de7d668e8ab3007397324234737f903b5af887" => :el_capitan
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
