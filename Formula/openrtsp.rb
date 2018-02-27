class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.02.26.tar.gz"
  sha256 "f56d534e79bc28d93d34532fa9b3329d83d840b7fe3c1ac8069f14d6f1d52093"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2425b94722f5de20bf1a87d1750828966913587c25bb72041cab08b905b4ba3" => :high_sierra
    sha256 "fed8851ec91da788a015e1bd09ff247a099f5270a7500e437dd01d324c6fa05e" => :sierra
    sha256 "7fc61d2635245ce6cfdbe4edccba70235a0b680938410ef928e53dfa6b73d653" => :el_capitan
  end

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
