class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.01.29.tar.gz"
  sha256 "f307e308faec29fe3c23f7cba6b80d5b0af7ba27f74d513e9286c9696a690503"

  bottle do
    cellar :any_skip_relocation
    sha256 "037f4f8d471339dd837c69af157284b139b46757cf59da90c3918acfcbd5c33a" => :high_sierra
    sha256 "8fa9edbf0e8654873b0543ac057c1dad613f1a8b5b22eee9773b2d72270744b4" => :sierra
    sha256 "536967a7568cbd3a0f35fda6274de5829076ec164d5b52c31b97cf4492fd4af4" => :el_capitan
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
