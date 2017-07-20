class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2017.07.18.tar.gz"
  sha256 "b2e857e47a9bac09958cbf313f160265067555f66f9282f10c6419d63c620ab6"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa86a336ff564264d0be3e97a6a79dc432c579cbe51dc540519560d03e33881" => :sierra
    sha256 "d7dcb01ce60df97a1987d39bdb10c3d5c8d0f164f70a9218b91b90fe51ac4382" => :el_capitan
    sha256 "e6fa2b2075c79ddbfbeeac27e62de684430ab876907c3485a7b24cef15436734" => :yosemite
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
