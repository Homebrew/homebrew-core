class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2016.09.22.tar.gz"
  sha256 "4d108205f4f0abe24224c72129222c1a8865e13d67e5dad6f8e900ef346379ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5d78176f52401abfd1226e1616ffb528960541b17f7e065ea18582fc752d481" => :sierra
    sha256 "f9cdf62c46fe15060aa84831283f9b2a91214f01e0da8cf185bea2abb597e11f" => :el_capitan
    sha256 "0288928ad21138b15680fb534f4c40f50254748c423f33e4000cf58946d2ede0" => :yosemite
  end

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles", "macosx-32bit"
    else
      system "./genMakefiles", "macosx"
    end

    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<-EOS.undent
    Testing executables have been placed in:
      #{libexec}
    EOS
  end
end
