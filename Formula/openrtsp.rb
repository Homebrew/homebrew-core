class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2017.07.18.tar.gz"
  sha256 "b2e857e47a9bac09958cbf313f160265067555f66f9282f10c6419d63c620ab6"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcba3cb824fa647cfc1da70b9b4592960e3552ba093d2bc75502e5a0a16c5a83" => :sierra
    sha256 "98551491f1f526da9688fe5b48348099277342a3de604ed9a75682bd4471e98e" => :el_capitan
    sha256 "130cd9e12a68ff5236cad1168c8246ca1d8c6da85d96ba129553b006fe595ff3" => :yosemite
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
