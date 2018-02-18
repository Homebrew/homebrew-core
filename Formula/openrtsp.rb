class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.02.12.tar.gz"
  sha256 "9df74e4a26561a7d3d694ecba26c5a9038aa5cd54a61d308b1343a7800060621"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2aacbf2b2b8d9be2b3476ef165fc109c11e18adf5e5712d58b4fc90fb930058" => :high_sierra
    sha256 "74f23cfbea38951b5edf7a1ecbd128ed98d90dd06e63f7b8abb4365708ec67d6" => :sierra
    sha256 "e2c9c1e08f0810ec608974421e17bfe7adeb94ffae31ca2d753e932f76aa7654" => :el_capitan
  end

  def install
    if MacOS.prefer_64_bit?
      system "./genMakefiles", "macosx"
    else
      system "./genMakefiles", "macosx-32bit"
    end

    # Build failure "error: unknown type name 'locale_t'"
    # Reported 17 Feb 2018 to support AT live555 DOT com
    system "make", "EXTRA_LDFLAGS=-DNEED_XLOCALE_H=1", "PREFIX=#{prefix}", "install"

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
