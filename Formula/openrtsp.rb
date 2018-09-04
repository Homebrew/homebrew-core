class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.08.28a.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2018.08.28a.tar.gz"
  sha256 "0aa6f60c8acf8a309119c02ad1bafca40af8105ce411ba2e6fdfbed9222f91ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb907e3564510bf18fd6c5638b0e38d729c4efab6a4a524e6debfb8e14b05707" => :mojave
    sha256 "b663986fb3f93865c709cb77ca319c8bdfcfd13b0cdaf23aa7581fef593e6e4e" => :high_sierra
    sha256 "2a321a7550ef89abf821f7b40cd5b996bbff1c096aa1f90ddbceaf48fcb0a55c" => :sierra
    sha256 "c74559f87612b80ae1cd1ad5c369f5b1732c91e03c92c929dc7f25159d0cec61" => :el_capitan
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
