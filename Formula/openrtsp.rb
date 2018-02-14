class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.01.29.tar.gz"
  sha256 "f307e308faec29fe3c23f7cba6b80d5b0af7ba27f74d513e9286c9696a690503"

  bottle do
    cellar :any_skip_relocation
    sha256 "c43b4a7df18efa47e07d36c5eec094cf32340f2daabc4fc3111eda77a83e7d70" => :high_sierra
    sha256 "281a802f98542a769468da8607d381c3d82f63cbc49ce867cc3e55bf0037c640" => :sierra
    sha256 "0f2cbe037b83a64f56a69fbef26062d839dc95b1843687fce377004e0b3a7f18" => :el_capitan
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
