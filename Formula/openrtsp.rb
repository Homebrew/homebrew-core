class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2016.11.28.tar.gz"
  sha256 "08b93a20bc302bed1da2f05621f37fda962dbfc272132afa6fa1058d222c238a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5d78176f52401abfd1226e1616ffb528960541b17f7e065ea18582fc752d481" => :sierra
    sha256 "f9cdf62c46fe15060aa84831283f9b2a91214f01e0da8cf185bea2abb597e11f" => :el_capitan
    sha256 "0288928ad21138b15680fb534f4c40f50254748c423f33e4000cf58946d2ede0" => :yosemite
  end

  def install
    if MacOS.prefer_64_bit?
      system "./genMakefiles", "macosx"
    else
      system "./genMakefiles", "macosx-32bit"
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

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
