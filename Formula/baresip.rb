class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/releases/download/v0.6.5/baresip-0.6.5.tar.gz"
  sha256 "2b035bd8b2121c72bec674768579a3bdcc5d1d567ecb0a84125864d69807b18d"

  bottle do
    sha256 "26b195eb72f39e12b796100935469105d0a07968cf38d9dc1febec3322e40939" => :big_sur
    sha256 "dd71d2ba58f82dd58b4da6c350b2d52ff4e04fe64679a446778615550dfb95b8" => :catalina
    sha256 "ec2fb4cba298c281b40a0929c227b563508ecaf5564e9381872c14469fb73ef9" => :mojave
    sha256 "b99e262d153eb3414c2a6fe813be98e78f71da205d66ede0ec799d1e07f0341a" => :high_sierra
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
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
                              "USE_UUID=1",
                              "HAVE_GETOPT=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t"
  end
end
