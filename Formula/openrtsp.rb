class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2017.06.04.tar.gz"
  sha256 "e1087863fea6e377ea4035a52e3b5e8f4a4bd79420da2fcc69b75fdcaddfc375"

  bottle do
    cellar :any_skip_relocation
    sha256 "975dda21ef232154130f688cba8eb7669e7c0adc54ceb2d8c8ed9d66c134a9df" => :sierra
    sha256 "857fc5e090a89d7abaa097b1e60a39de7258da4c31f5e4f662e39757986a4eeb" => :el_capitan
    sha256 "e537e6da154868fa005a0c67ef10bf0e4c5508a69f655be2e50427d28903e61b" => :yosemite
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
