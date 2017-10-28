class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2017.10.28.tar.gz"
  sha256 "d8eaec9ded34321aa655d3c9007217dd447218c54cb48c97827e58ecd5edb338"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bb26ef8c5e79d4b24d3e7e557180a68df746f61e71a762a79de42e09c586bc9" => :high_sierra
    sha256 "67b97b37e48f3fe3bbe7ab1894eaa9e91e333c1b001bc389cde3c0a113b97174" => :sierra
    sha256 "d40bc9a8f3cb2a55ca934aa4a6168685babf6cbebfb23ea99f97c2d8e44e3df6" => :el_capitan
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
