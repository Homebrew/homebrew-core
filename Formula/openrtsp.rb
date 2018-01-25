class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.01.24.tar.gz"
  sha256 "81d8167e26d418caece4374ff61c8100814def14cbe1173f3a8ad6842f607cb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "33d46ff647a933772afe3ffd13870f9b7226a995299b3d717918a4101975697e" => :high_sierra
    sha256 "df76c6f6c2ebe06848a6206694aaf5f36c847ddd5a2cf7e12d52fb25c7033273" => :sierra
    sha256 "82d4b641872c3eb160a4107c593f9f36700433ce686111b91cf28e9bc9dde54c" => :el_capitan
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

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
